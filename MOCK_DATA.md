# Mock data

For setup and scheme selection, see the [repository README](README.md). This document describes the bundled fixtures, their provenance, and the transformations intentionally applied in mock mode.

The fixture set contains:

- `App/Resources/Mocks/launches.json` — 60 launches.
- `App/Resources/Mocks/rockets.json` — 4 rockets.
- `App/Resources/Mocks/launchpads.json` — 3 launchpads.

## Launches

`App/Resources/Mocks/launches.json` contains 60 unmodified launch objects from an archived `GET /v4/launches` response. The source snapshot contains 205 records and was recovered from the Wayback Machine by the [android-spacex-app API server](https://github.com/nisrulz/android-spacex-app/blob/main/docs/api-server.md); its [v4 JSON file](https://github.com/nisrulz/android-spacex-app/blob/main/api-server/server/data/launches_v4.json) is the input used here.

The fixture selects the 60 most recent completed launches that have a `links.flickr.original` photo and sorts them by `date_utc` descending. The dates run from January 2020 through April 2022. IDs, mission names, dates, status, links, and other launch fields are copied from the snapshot. No launches are duplicated or invented. The archived `upcoming` entries were excluded because their planned dates are now in the past.

`MockLaunchesService` applies the selected launch-date interval before slicing this array into pages, then creates the documented `POST /v4/launches/query` response shape in memory. Both selected calendar days are inclusive; an omitted bound is unrestricted. A detail lookup returns one of the same launch objects, matching `GET /v4/launches/:id`. The [API query documentation](https://github.com/r-spacex/SpaceX-API/blob/master/docs/queries.md) defines the response fields and date operators used by the network request builder.

The API's `links.patch` URLs currently return an imgbox placeholder in our checks. The list instead uses a 240-pixel Flickr variant of `links.flickr.original`; [Flickr documents the size suffixes](https://www.flickr.com/services/api/misc.urls.html). If a remote image fails, the app shows its existing SF Symbol placeholder.

Some launch records have `details: null`. The detail screen displays a short mission summary assembled from that record's real name and date plus its referenced launchpad and rocket; the source JSON remains unchanged.

## Rockets

`App/Resources/Mocks/rockets.json` is the four-record archived v4 rocket response from the [same API server snapshot](https://github.com/nisrulz/android-spacex-app/blob/main/api-server/server/data/rockets.json). Rocket IDs, names, descriptions, specs, and Flickr image URLs are copied from that response. Its Falcon 9 ID matches the 60 launch records.

The rocket list uses the request's page size, which defaults to ten records, and displays each record's `success_rate_pct` value. The two Imgur photos in the Falcon 1 record currently return HTTP 429. For that rocket, the mock service uses a [U.S. Air Force photo of Falcon 1](https://commons.wikimedia.org/wiki/File:Falcon_1_engine_test.jpg) (public domain) instead; the archived JSON remains unchanged.

## Launchpads

`App/Resources/Mocks/launchpads.json` contains the three pads referenced by the selected launches. Their IDs, names, and full names match the [v4 launchpad records](https://spacex-one.vercel.app/launchpad), which retain the original SpaceX API response fields. The launchpad file in the archived server has generated IDs that do not match the launch snapshot, so it cannot be used for these references.
