
# Movie App

GLI Technical Test Option 1

## Authors

- [@adedwi1808](https://www.github.com/adedwi1808)


## Installation (**REQUIRED**)

Clone This Project And Fill The Development.xcconfig with Your ACCESS_TOKEN
if you doesn't had the token you can get it from here
https://developer.themoviedb.org/reference/intro/getting-started
    
## API Reference

#### Get Popular Movies

```http
  GET [https://api.themoviedb.org)/3/movie/popular
```

| Parameter | Data Type| Type | Description                       |
| :-------- | :------- | :------| :-----------------------------------|
| `page`      | `string` | 'Query Params' | **Required**.|



#### Get Movie Detail

```http
  GET https://api.themoviedb.org)/3/movie/{id}
```

| Parameter | Data Type| Type | Description                       |
| :-------- | :------- | :------| :-----------------------------------|
| `id`      | `string` | 'Path Params' | **Required**. it's the movie identifier|


#### Get Movie Videos (For Trailer)

```http
  GET https://api.themoviedb.org)/3/movie/{id}/videos
```

| Parameter | Data Type| Type | Description                       |
| :-------- | :------- | :------| :-----------------------------------|
| `id`      | `string` | 'Path Params' | **Required**. it's the movie identifier|


#### Get Movie Reviews

```http
  GET https://api.themoviedb.org)/3/movie/{id}/reviews
```

| Parameter | Data Type| Type | Description                       |
| :-------- | :------- | :------| :-----------------------------------|
| `id`      | `string` | 'Path Params' | **Required**. it's the movie identifier|
| `page`      | `string` | 'Query Params' | **Required**.|


## Tech Stack

**Client:** UIKit, SWIFT, MVVM, Async-await, URLSession, SPM, RXSwift, YouTubePlayeriOSHelper

