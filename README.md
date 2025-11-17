## Dokumentasi Folder
- bindings/ = sambung controller <-> view via Get.put() otomatis
- controllers/ = controller global (misal theme controller, auth controller)
- core/config/ = .env, API key, base URL, constant value
- core/theme/ = warna, typography, style global
- core/utils/ = helper fungsi(format date, log)
- data/models/ = kelas model dari response API(MovieModel, GenreModel)
- data/providers/ = API call logic(pake Dio/http)
- data/repositories/ = abstraksi untuk ambil data dari API/lokal/cache
- domain/ = opsional
- modules/ = featured based folder(home, movie, search, detail)
- routes/ = semua navigasi(GetPage routes)
- services/ = Hive, SharedPreferences
- widgets/ = komponen global UI reusable

## Endpoint TMDB API
# HOME PAGE
- GET /movie/now_playing     - Carousel banner
- GET /movie/popular         - Most Popular section
- GET /movie/top_rated       - Top Rated (optional)
- GET /genre/movie/list      - Untuk mapping genre ID ke nama

# SEARCH PAGE
- GET /search/movie          - Search movies by keyword
- GET /search/multi          - Search movies, TV, people

# SEARCH BY ACTOR PAGE
- GET /search/person         - Search actors by name
- GET /person/{person_id}/movie_credits  - Movies by actor

# MOVIE DETAIL PAGE
- GET /movie/{movie_id}                  - Movie detail
- GET /movie/{movie_id}/credits          - Cast & Crew
- GET /movie/{movie_id}/similar          - Similar movies
- GET /movie/{movie_id}/videos           - Trailers (optional)
- GET /movie/{movie_id}/images           - Movie images (optional)

# WISHLIST PAGE
- LOCAL STORAGE - Tidak perlu API
   - Gunakan shared_preferences atau hive untuk save favorite

# DOWNLOAD PAGE
- LOCAL STORAGE - Tidak perlu API
   - Gunakan local database untuk track downloaded movies