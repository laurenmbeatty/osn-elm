module PhotoGallery exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

-- MODEL

type alias Model =
  { query : String
  , results : List SearchResult
  , initialIndex : Int
  }

type alias SearchResult =
  { likes : Int
  , user : PhotosUser
  , urls : PhotosUrls
  }

type alias PhotosUrls =
  { small : String
  , regular : String
  , full : String
  }

type alias PhotosUser =
  { username : String }

type Msg
  = PhotosResult (Result Http.Error (List SearchResult))

getPhotos : Cmd Msg
getPhotos =
    Http.send PhotosResult <|
      Http.get "https://api.unsplash.com/photos/?page=2&per_page=24&client_id=TODOClientIDhere" decodePhotosList

init : (Model, Cmd Msg)
init =
  ({ query = "json server", results = [], initialIndex = 0 }, getPhotos)

 -- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      PhotosResult (Ok results) ->
        ({ model | results = results, query = ""}, Cmd.none)
      PhotosResult (Err err) ->
        ({ model | results = [], query = (toString err) }, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  div [class "main-container"]
  [
  div [ class "image-container"] (List.indexedMap viewSearchResult model.results)
  ]


viewSearchResult : Int -> SearchResult -> Html Msg
viewSearchResult index result =
  div [ classList [("smallgrid", True), ("odd", ((index + 1) % 2 == 0)), ("even", ((index + 1) % 2 /= 0))]]
  [
    div [ class "description" ]
      [ div [ class "text-holder" ]
          [ h3 []
              [ text "Photographer:" ]
          , h2 []
              [ text result.user.username ]
          , p []
              [ text ("[Likes: " ++ (toString result.likes) ++ "]") ]
          ]
      ]
      ,
      div [ class "photo" ]
        [ img [ src (result.urls.small) ] []
        ]
  ]

plusOne : Int -> Int
plusOne num =
  num + 1

decodePhotosList : Json.Decode.Decoder (List SearchResult)
decodePhotosList =
  Json.Decode.list decodePhoto

decodePhotosUser : Json.Decode.Decoder PhotosUser
decodePhotosUser =
    Json.Decode.Pipeline.decode PhotosUser
        |> Json.Decode.Pipeline.required "username" (Json.Decode.string)

decodePhotosUrls : Json.Decode.Decoder PhotosUrls
decodePhotosUrls =
    Json.Decode.Pipeline.decode PhotosUrls
        |> Json.Decode.Pipeline.required "small" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "regular" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "full" (Json.Decode.string)

decodePhoto : Json.Decode.Decoder SearchResult
decodePhoto =
    Json.Decode.Pipeline.decode SearchResult
        |> Json.Decode.Pipeline.required "likes" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "user" (decodePhotosUser)
        |> Json.Decode.Pipeline.required "urls" (decodePhotosUrls)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
