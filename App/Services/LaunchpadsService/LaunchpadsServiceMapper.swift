struct LaunchpadsServiceMapper {
    func map(_ dto: LaunchpadDTO) -> Launchpad {
        Launchpad(id: dto.id, name: dto.name, fullName: dto.fullName)
    }
}
