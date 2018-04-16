module PhotoGallery exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
--import Array exposing (Array)
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
  = GetPhotos
  | PhotosResult (Result Http.Error (List SearchResult))

init : (Model, Cmd Msg)
init =
  ({ query = "json server", results = [], initialIndex = 0 }, Cmd.none)

-- initialModel : Model
-- initialModel =
--   Model


 -- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      GetPhotos ->
        let
          cmd =
            Http.send PhotosResult <|
              Http.get "https://api.unsplash.com/photos/?page=2&per_page=24&client_id=TODOputclientidhere" decodePhotosList
        in
          ( model, cmd )

      PhotosResult (Ok results) ->
        ({ model | results = results, query = ""}, Cmd.none)
      PhotosResult (Err err) ->
        ({ model | results = [], query = (toString err) }, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  div [class "main-container"]
  [
    button
        [onClick GetPhotos]
        [text "Get Photos"]
  ,
  div [ class "image-container"] (List.map viewSearchResult model.results)
  ]


viewSearchResult : SearchResult -> Html Msg
viewSearchResult result =
  div [ classList [("smallgrid", True), ("odd", True), ("even", False)]]
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
