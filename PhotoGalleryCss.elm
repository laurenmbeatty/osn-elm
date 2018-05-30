module PhotoGalleryCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)

css : Stylesheet
css = 
    stylesheet
        [
            body
            [ margin (px 50)
            , color (hex "323031")
            , backgroundColor (hex "A3A866")
            , backgroundColor (hex "2a9ec1")
            , fontFamily ("Lato" "sans-serif")
            ]
            ,
            h2
            [ fontFamily ("Montserrat" "sans-serif")]
            ,
            h3
            [ fontFamily ("Montserrat" "sans-serif")]
            ,
            h2
            [ fontSize (em 1.6)
            , margin (px 0 30 5 30)
            , textTransform uppercase
            , wordWrap breakWord
            , maxWidth (px 200)
            ]
            ,
            h3
            [ fontSize (em 0.9)
            , margin (px 0 30 5 30)
            , textTransform uppercase
            ]
            ,
            p
            [ margin (px 0 30)]
            ,
            (.) "search-container"
            [ display flex
            , justifyContent flexEnd
            , marginBottom (px 50)
            ]
            ,
            (.) "search-input"
            [ padding (px 8)
            , fontSize (px 24)
            ]
            ,
            (.) "search-button"
            [ padding (px 8 16)
            , fontSize (px 24)
            , color (hex "ffffff")
            , border none
            , backgroundColor (hex "2a9ec1")
            , hover
                [ color (hex "2a9ec1")
                , backgroundColor (hex "ffffff")
                ]
            ]
            ,
            (.) "image-container"
            [ margin auto
            , width (vw 90)
            , display grid
            , gridRowGap (px 15)
            , gridTemplateColumns (repeat(auto-fill, minmax(350px, 1fr))) ]
        ]