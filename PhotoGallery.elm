module PhotoGallery exposing (Error(..), Model, Msg(..), PhotosUrls, PhotosUser, SearchResult, decodePhoto, decodePhotosList, decodePhotosUrls, decodePhotosUser, getPhotos, includeAltText, init, main, onEnter, subscriptions, update, view, viewErrorMessage, viewSearchResult)

import Auth
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)



-- MODEL


type alias Model =
    { results : List SearchResult
    , initialIndex : Int
    , query : String
    }


type alias SearchResult =
    { likes : Int
    , description : Maybe String
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


type Error
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus (Http.Response String)
    | BadPayload String (Http.Response String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { query = "Dogs", results = [], initialIndex = 0 }, getPhotos "Dogs" )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PhotosResult (Ok results) ->
            ( { model | results = results, query = "" }, Cmd.none )

        PhotosResult (Err err) ->
            ( { model | results = [], errorMessage = Just "Oops, something went wrong." }, Cmd.none )


getPhotos : String -> Cmd Msg
getPhotos query =
    let
        url =
            "https://api.unsplash.com/search/photos?page=2&per_page=24&query="
                ++ query
                ++ "&client_id="
                ++ Auth.token
    in
    Http.send PhotosResult <|
        Http.get url decodePhotosList


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.Decode.succeed msg

            else
                Json.Decode.fail "not ENTER"
    in
    on "keydown" (Json.Decode.andThen isEnter keyCode)



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "main-container" ]
        [ h1 [ class "visually-hidden" ] [ text "Elm Demo with Unsplash API" ]
        , div [ class "search-container" ]
            [ label [ for "search", class "visually-hidden" ] [ text "Search" ]
            , input [ class "search-input", id "search", onInput SetQuery, onEnter Search ] []
            , button [ class "search-button", onClick Search ] [ text "Search" ]
            ]
        , viewErrorMessage model.errorMessage
        , div [ class "image-container" ] (List.indexedMap viewSearchResult model.results)
        , div [ class "credit " ]
            [ a [ href "https://codepen.io/andybarefoot/pen/GMyREX", target "_blank" ] [ text "design by @andybarefoot" ]
            ]
        ]


viewErrorMessage : Maybe String -> Html Msg
viewErrorMessage errorMessage =
    case errorMessage of
        Just message ->
            h4 [ class "error-message" ] [ text message ]

        Nothing ->
            text ""


viewSearchResult : Int -> SearchResult -> Html Msg
viewSearchResult index result =
    div [ classList [ ( "smallgrid", True ), ( "odd", remainderBy 2 (index + 1) == 0 ), ( "even", remainderBy 2 (index + 1) /= 0 ) ] ]
        [ div [ class "description" ]
            [ div [ class "text-holder" ]
                [ h2 []
                    [ text "Photographer:" ]
                , h3 []
                    [ text result.user.username ]
                , p []
                    [ text ("[Likes: " ++ String.fromInt result.likes ++ "]") ]
                ]
            ]
        , div [ class "photo" ]
            [ img [ src result.urls.small, alt (includeAltText result) ] []
            ]
        ]


includeAltText : SearchResult -> String
includeAltText result =
    case result.description of
        Nothing ->
            "Photo by " ++ result.user.username

        Just description ->
            description


decodePhotosList : Json.Decode.Decoder (List SearchResult)
decodePhotosList =
    Json.Decode.at [ "results" ] (Json.Decode.list decodePhoto)


decodePhotosUser : Json.Decode.Decoder PhotosUser
decodePhotosUser =
    Json.Decode.succeed PhotosUser
        |> Json.Decode.Pipeline.required "username" Json.Decode.string


decodePhotosUrls : Json.Decode.Decoder PhotosUrls
decodePhotosUrls =
    Json.Decode.succeed PhotosUrls
        |> Json.Decode.Pipeline.required "small" Json.Decode.string
        |> Json.Decode.Pipeline.required "regular" Json.Decode.string
        |> Json.Decode.Pipeline.required "full" Json.Decode.string


decodePhoto : Json.Decode.Decoder SearchResult
decodePhoto =
    Json.Decode.succeed SearchResult
        |> Json.Decode.Pipeline.required "likes" Json.Decode.int
        |> Json.Decode.Pipeline.optional "description" (Json.Decode.map Just string) Nothing
        |> Json.Decode.Pipeline.required "user" decodePhotosUser
        |> Json.Decode.Pipeline.required "urls" decodePhotosUrls


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
