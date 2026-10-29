# Destination map

The Application screen uses offline Natural Earth country coastlines, projected once into Natural Earth I coordinates. No map server, API, runtime network access or generated map artwork is used.

## Sources and reuse

- Data: `ne_110m_admin_0_countries.geojson` for the overview and `ne_50m_admin_0_countries.geojson` for the Europe close-up, downloaded 2026-10-28 from https://github.com/nvkelso/natural-earth-vector/tree/master/geojson . Originals retained here; Europe coastlines are simplified at 0.025° before projection.
- Natural Earth terms: https://www.naturalearthdata.com/about/terms-of-use/ . Public domain; free to modify and redistribute.
- Projection: Natural Earth I forward coefficients adapted from https://github.com/d3/d3-geo/blob/main/src/projection/naturalEarth1.js . Copyright 2010–2024 Mike Bostock; ISC, retained at `Licenses/d3-geo-ISC.txt`.
- UI guidance: Apple's HIG Motion and Pointing Devices. Subdued pointer feedback, standard controls and semantic colors; Reduce Motion removes lift/shadow, preserving hover contrast.

Run `python3 DesignResources/Maps/generate.py` to regenerate `VisaDone/Resources/Maps/destination-map.json`. AppKit/SwiftUI renders these vector coastlines at the available window size. Country data uses the upstream definitions. Russia's geography is split at 60°E for simplified continent selection; negative-longitude Chukotka fragments across the antimeridian remain in Asia, including in the Europe close-up exclusion; French Guiana is grouped geographically with South America. All seven continents are retained. Inner lake rings are omitted.

## Presented flow

The six displayed continent silhouettes, including their islands, respond to hover with a shallow 2.5pt solid lift and a short 180ms transition. A Canvas-rendered top surface and opaque side wall give the lifted continent thickness, with a small ground clearance and cast shadow. Native pointer and keyboard activation are retained. Only Europe opens a further page, as requested for the demo; no other region flow is implemented and no unavailable/demo labels are shown in the interface.

Europe contains an offline country map and a native NSSearchField above the country index. Map and index share selection and hover, with a small footer showing the chosen destination. Search accepts Chinese and English names. This pass ends at destination selection; visa-type forms and later application steps are not added.

The existing window background, titlebar navigation, Discovery, Notifications and Profile remain intact.

## Ongoing application

A nonmodal drawer in the bottom-left contains one ongoing Iceland application. It opens by default, supports header dragging and click/keyboard expansion, and snaps between two heights. The collapsed height displays only the heading 我的申请; destination, visa type, status and progress are disclosed below that heading when expanded. The native linear ProgressView and four captions distinguish document preparation, submission appointment, waiting for a result and completion. The summary reports personal preparation readiness (initially 6/10), not an authority's review status. The continue action opens a local preparation checklist; native checkbox changes update the summary progress. No backend or submission is added.

## Terrain and continuous ocean

Natural Earth II by Tom Patterson, public domain: https://www.shadedrelief.com/NE2/ . The original 4000×2000 land-cover and relief raster with flat blue water is retained as `NE2_flat_ocean.png`, downloaded from https://www.flexprojector.com/data/NE2_flat_ocean.png.zip . It is reprojected by `project_terrain.py` to the exact Natural Earth I coordinates of the vector boundaries, then bundled at `VisaDone/Resources/Maps/destination-terrain.png`. The script uses Pillow and NumPy. This is geographic reprojection of source data, not AI-generated scenery.

Each land silhouette clips the same terrain raster and overlays vector country/region borders. Hover lifts the terrain with its coastline. The full Application background uses the raster's exact flat ocean RGB (111,171,211), extending to the window edges, so there is no separate rectangular map backdrop. Dark appearance applies a matching darker palette to terrain and surrounding water. Other app pages retain the existing window material.

## Native globe overview

The overview uses Apple's native SceneKit with Metal rendering and AppKit pointer, scroll and keyboard events. No WebKit, JavaScript engine, Cesium runtime, web server or network map service is included.

The full WGS84 ellipsoid uses geodetic latitude, flattening 1/298.257223563, and a complete 360° × 180° texture. `generate_globe.py` prepares seven geographic regions and RGBA masks directly from raw longitude/latitude; Antarctica is retained. `prepare_globe_palette.py` reduces relief contrast and creates muted land / deep-ocean colors with country boundaries, independently of the projected Europe map. The same terrain colors are shown in Light and Dark appearances without the old blue overlay.

A fixed 21° vertical camera at four equatorial radii frames Europe and the Mediterranean. SceneKit handles viewport aspect ratio. Dragging, wheel input and arrow keys rotate; zoom remains disabled. The globe renders on demand rather than continuously updating an embedded web page.

Only the hovered continent's masked surface is displayed above the base ellipsoid. It rises by 0.7% of the equatorial radius and has native coastline side-wall geometry for depth. Picking uses only the base ellipsoid and converts the hit point back to geodetic latitude/longitude. Only Europe opens a further destination page.

The scene fills a background that ignores the top safe area and extends under the native toolbar. A native SwiftUI scroll container registers the `.soft` top edge, with user scrolling disabled so it does not compete with globe rotation. No titlebar accessory or custom blur panel inserts another row. The existing application drawer and sample contents are preserved.

## MapTiler native tiles

When `VisaDone/Resources/MapTiler.local.json` exists with a client API key and map ID, the same native SceneKit globe loads MapTiler raster XYZ tiles using URLSession. This local configuration file is Git-ignored. Copy `MapTiler.local.example.json` to that location and fill in your own values; the selected map ID is `landscape-v4`. No account-management page, WebKit, JavaScript or MapKit is used. The selected public preset contains text labels; a separately published custom map ID is required to remove them and any unwanted boundary layers.

The globe retains its fixed 21° vertical field of view, WGS84 shape, native rotation and continent lift. Tiles use native subdivided geographic meshes: Web Mercator tile rows are converted with the inverse Mercator formula to latitude before placing vertices on the ellipsoid. Raster tile UVs remain in their source projection, preventing the stretch caused by applying a Mercator image to a longitude/latitude sphere directly. Raised continent tile masks are generated in the same Mercator coordinates.

Requests identify as `VisaDone/1.0`, omit Origin, and load only tiles intersecting the current view and front hemisphere after a 250 ms interaction debounce. The fixed zoom is 4, with 1024 px `@2x` tiles. There are at most four simultaneous requests, and already loaded tiles are reused while dragging. Visited native surfaces are retained for the app session instead of being evicted after 80 tiles. The fixed zoom has at most 256 tiles worldwide; only areas actually visited are requested. In-flight successful responses are retained even if the user rotates away before they finish.

URLCache uses 32 MB memory and 256 MB disk under the app's Caches directory, with `.useProtocolCachePolicy`. The server's Cache-Control response is respected; no permanent map atlas or offline export is written. The observed tile response on 2026-10-29 was `public, max-age=28800` (8 hours), but the implementation follows the actual response rather than hardcoding this value. Expired entries are handled by URLSession. Authentication failure stops further requests; no URLs containing the client key are logged.

Attribution uses the official MapTiler logo and clickable MapTiler / OpenStreetMap credits. Official documentation: https://docs.maptiler.com/cloud/api/maps/ , https://docs.maptiler.com/guides/developer/credentials/api-key/ , https://docs.maptiler.com/guides/map-design/attribution/add-attribution/ . Cloud caching terms: https://www.maptiler.com/terms/cloud/ . The local texture remains a fallback during loading or failed requests.

### View lifetime

`VisaDoneModel.destinationGlobeStore` lazily owns the native globe. SwiftUI can remove and reattach the representable during tab changes or Europe navigation without recreating SceneKit, resetting the camera, or reinstalling previously loaded textures. Only view callbacks are cleared on dismantle. This is distinct from HTTP caching: a disk-cache hit previously still required rebuilding geometry and uploading images to the GPU. First-time viewing of an uncached region still needs its images; app restarts recreate renderer memory and use the normal HTTP cache.

## Active Mapbox style

A valid ignored `VisaDone/Resources/Mapbox.local.json` takes priority over the optional MapTiler configuration. The selected style is `mapbox://styles/thelloydme/cmvsswj9n003d01rm3myy3gnr` (Outdoors), used identically in Light and Dark appearances. There is no appearance-specific map ID, recoloring, or style reload. The account and published style are configured locally; the token is not included in version control. `Mapbox.local.example.json` documents the expected fields.

`GlobeRasterTiles.swift` loads the published Classic style through Mapbox Static Tiles API using 512 px tiles at @2x. The same inverse-Mercator native geometry, continent mask alignment, session-owned scene, visited-tile retention, four-request concurrency and protocol-based URLCache are reused. Mapbox responses use a separate `VisaDone/Mapbox` HTTP cache directory. The observed response on 2026-10-29 was `max-age=43200,s-maxage=7200`; client caching follows the actual response headers. No tile atlas or permanently exported map is written.

The style metadata and a native tile request both returned HTTP 200. Its remaining visible symbol layers start at zoom 16; the globe's fixed zoom 4 therefore has no such text. The map's original colors and boundary visibility are preserved without changing the published style. Mapbox Standard imports are not used. Mapbox attribution includes the official wordmark and clickable Mapbox, OpenStreetMap and Improve this map links. Wordmark source: official Mapbox GL JS CSS at https://api.mapbox.com/mapbox-gl-js/v3.16.0/mapbox-gl.css . Only the supplied logo is used; no JS/CSS renderer is embedded.

### Complete Mapbox offline globe (2026-10-29)

Mapbox mode now prepares every tile of the fixed z=4 world (16 × 16 = 256, 1024 px each), with the first viewport prioritized. The full set is about 65 MB for the selected style. Files live in the current user's Application Support/VisaDone/MapboxOffline directory (inside the app container when sandboxed), separated by owner, style ID and resolution. Valid files are read directly without an HTTP request; their maximum lifetime is 30 days. Expired files are removed and fetched again. This follows Mapbox's client-side Static Tiles caching allowance: https://www.mapbox.com/static-maps/ . The set is not bundled or redistributed with the app.

Native tile nodes stay hidden until all 256 tiles have decoded and SceneKit has prepared their GPU resources. They are revealed together in a transaction without animation. Until then, the complete bundled fallback globe remains visible. No newly downloaded tiles are installed visibly one at a time. The prepared whole world remains attached to the session-owned SceneKit view, so rotation, tab switching and returning from Europe do not fetch more tiles. Restarting the app recreates renderer resources from local files. First setup on a new device, manually removed cache files, or 30-day expiry requires a network connection; a failed download keeps the complete fallback globe and retries rather than displaying a partial set. Optional MapTiler mode retains its original visible-area HTTP cache behavior.

### Europe selection in the globe drawer

The world level no longer raises or extrudes continents on pointer hover. Geographic hit testing is retained to select Europe. Selecting Europe keeps the same session-owned native globe and cached textures visible; SceneKit animates orientation to yaw 8°, pitch 45° at the existing fixed camera scale, placing Europe to the right of the destination drawer. Reduced Motion disables this transition. Returning to the world view restores yaw −24°, pitch 38°.

The bottom-left application panel becomes an expanded new-application destination picker. Country rows use SwiftUI's native macOS List with inset styling and native selection/keyboard navigation, plus locally bundled, circularly cropped flag-icons SVGs and Chinese / English country names. Search uses NSSearchField. The drawer can still collapse or expand by dragging or clicking its heading. The previous flat Europe page is no longer part of this flow; current application data remains intact and is shown again when returning to the world.

### Destination drawer refinements

The native glass back button is a circular system button immediately below the window toolbar, outside the drawer. The expanded destination drawer reaches higher (up to 740 pt, leaving room above for Back). Countries sort by English name with case/diacritic-insensitive collation. The extra region labels were removed. Search remains NSSearchField, now extraLarge with 15 pt text in a 44 pt native Liquid Glass surface. The search accessory uses SwiftUI safeAreaBar on the native List, extending the system soft scroll-edge effect behind the field. The list's full scroll bounds begin directly below the drawer heading rather than below a separate search row.

### Toolbar sizing and country focus

The destination page measures the actual four-segment navigation control height from the current native window and shares it between Back and Search (32 pt fallback for previews without the window toolbar). Back uses NSButton with the native glass bezel, circular border shape, regular control size and 13 pt symbol. NSSearchField returns to regular sizing and 13 pt text; the native glass surface follows the measured toolbar height rather than a hardcoded 44 pt extraLarge control.

Only the Europe level enables country hover / selection. generate_globe_countries.py retains public-domain Natural Earth 50m outlines in longitude/latitude, without the old flat-map projection. Both picking and focus use those coordinates. A shallow translucent accent fill and fine curved outline follow the same WGS84 ellipsoid and depth test as the map. The fill uses a local country-bounds alpha mask; no new map requests or raised country slabs are involved. A handful of surfaces are retained on demand. Native hover tooltips display bilingual names. The list shares hover and selected state with the globe; clicking a country selects/reveals its native list row. The world-level continents remain flat and have no hover overlay.
