import Foundation

@MainActor
final class PaginationController<Payload: Sendable> {
    struct Page: Sendable {
        let payload: Payload
        let number: Int
        let hasNextPage: Bool
    }

    typealias Loader = @MainActor (Int) async throws -> Page
    typealias SuccessHandler = @MainActor (Page) -> Void
    typealias FailureHandler = @MainActor () -> Void

    private let firstPage: Int
    private var nextPage: Int
    private var hasNextPage = true
    private var requestTask: Task<Void, Never>?

    private var canLoadNextPage: Bool {
        requestTask == nil && hasNextPage
    }

    init(firstPage: Int = 1) {
        self.firstPage = firstPage
        nextPage = firstPage
    }

    deinit {
        requestTask?.cancel()
    }

    func loadFirstPage(
        using loader: @escaping Loader,
        onSuccess: @escaping SuccessHandler,
        onFailure: @escaping FailureHandler
    ) {
        cancel()
        startLoading(
            page: firstPage,
            using: loader,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }

    @discardableResult
    func loadNextPage(
        using loader: @escaping Loader,
        onSuccess: @escaping SuccessHandler,
        onFailure: @escaping FailureHandler
    ) -> Bool {
        guard canLoadNextPage else { return false }

        startLoading(
            page: nextPage,
            using: loader,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
        return true
    }

    func cancel() {
        requestTask?.cancel()
        requestTask = nil
    }

    private func startLoading(
        page: Int,
        using loader: @escaping Loader,
        onSuccess: @escaping SuccessHandler,
        onFailure: @escaping FailureHandler
    ) {
        requestTask = Task { @MainActor [weak self] in
            do {
                let result = try await loader(page)
                try Task.checkCancellation()

                guard let self else { return }
                requestTask = nil
                nextPage = result.number + 1
                hasNextPage = result.hasNextPage
                onSuccess(result)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled, let self else { return }
                requestTask = nil
                onFailure()
            }
        }
    }
}
