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

## Environment Variables

- **TMDB_API_KEY** = *API key Anda*
- **TMDB_BASE_URL** = `https://api.themoviedb.org/3`
- **TMDB_IMAGE_BASE_URL** = `https://image.tmdb.org/t/p/w500`
- **LANG** = `en-US`
- **MOVIE_ID** = (opsional, isi jika butuh)
- **PERSON_ID** = (opsional, isi jika butuh)

## 📌 HOME PAGE ENDPOINTS

### 🎬 Now Playing Movies
```
GET {{TMDB_BASE_URL}}/movie/now_playing?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

### ⭐ Popular Movies
```
GET {{TMDB_BASE_URL}}/movie/popular?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

### 🏆 Top Rated Movies
```
GET {{TMDB_BASE_URL}}/movie/top_rated?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

### 🏷️ Movie Genres
```
GET {{TMDB_BASE_URL}}/genre/movie/list?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

---

## 🔍 SEARCH PAGE

### 🔎 Search Movies
```
GET {{TMDB_BASE_URL}}/search/movie?api_key={{TMDB_API_KEY}}&language={{LANG}}&query=batman
```

### 🔎 Search Multi (Movies, TV, People)
```
GET {{TMDB_BASE_URL}}/search/multi?api_key={{TMDB_API_KEY}}&language={{LANG}}&query=batman
```

---

## 🧑‍🎤 SEARCH BY ACTOR PAGE

### 👤 Search Person
```
GET {{TMDB_BASE_URL}}/search/person?api_key={{TMDB_API_KEY}}&language={{LANG}}&query=brad+pitt
```

### 🎥 Actor Movie Credits
```
GET {{TMDB_BASE_URL}}/person/{{PERSON_ID}}/movie_credits?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

---

## 🎞️ MOVIE DETAIL PAGE

### 📘 Movie Detail
```
GET {{TMDB_BASE_URL}}/movie/{{MOVIE_ID}}?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

### 🎭 Movie Credits
```
GET {{TMDB_BASE_URL}}/movie/{{MOVIE_ID}}/credits?api_key={{TMDB_API_KEY}}
```

### 🎬 Similar Movies
```
GET {{TMDB_BASE_URL}}/movie/{{MOVIE_ID}}/similar?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

### 📺 Movie Videos (Trailers)
```
GET {{TMDB_BASE_URL}}/movie/{{MOVIE_ID}}/videos?api_key={{TMDB_API_KEY}}&language={{LANG}}
```

### 🖼️ Movie Images
```
GET {{TMDB_BASE_URL}}/movie/{{MOVIE_ID}}/images?api_key={{TMDB_API_KEY}}
```
