module Login.Styles exposing (styles, Classes(..), scopedId, scopedClass, scopedClassList)

import Css exposing (..)
import Css.Elements exposing (h1, input, label)
import Common.Colors exposing (..)
import Css.Namespace
import Common.CssHelpers as CssHelpers


{ scopedId, scopedClass, scopedClassList, namespace } =
    CssHelpers.withNamespace "login"


type Classes
    = Page
    | Background
    | Container
    | Icon
    | Button
    | SubmitButton
    | Step
    | StepTitle
    | StepForm
    | PasswordStep
    | FilledEmail


styles : Stylesheet
styles =
    (stylesheet << Css.Namespace.namespace namespace)
        [ class Page
            [ height (pct 100)
            , width (pct 100)
            , position absolute
            , margin2 (pct 0) auto
            ]
        , class Background
            [ backgroundImage (url "images/streets.svg")
            , backgroundColor primaryBlue
            , backgroundSize cover
            , textAlign center
            , lightTextColor
            , height (pct 100)
            ]
        , class Container
            [ displayFlex
            , justifyContent spaceBetween
            , flexDirection column
            , height (pct 100)
            , property "background" "linear-gradient(rgb(52, 103, 255) 0%, rgba(52, 103, 255, .96) 50%, rgba(52, 103, 255, .9) 100%)"
            , overflow hidden
            ]
        , class Icon
            [ display none
            ]
        , class Step
            [ padding (px 40)
            , descendants
                [ h1
                    [ fontSize (px 32)
                    ]
                , input
                    [ important <| borderBottom3 (px 1) solid white
                    ]
                , label
                    [ important <| lightTextColor
                    ]
                , class Button
                    [ width (pct 100)
                    , lightTextColor
                    ]
                , class SubmitButton
                    [ color primaryBlue
                    , backgroundColor white
                    , hover
                        [ backgroundColor grey
                        ]
                    ]
                ]
            ]
        , class StepForm
            [ flexGrow (int 2)
            , displayFlex
            , flexDirection column
            , justifyContent spaceBetween
            ]
        , class PasswordStep
            [ property "animation" "slide-in 0.5s forwards"
            ]
        , slideInAnimation
        , class FilledEmail
            [ textAlign left
            ]
        , desktopStyles
        ]


slideInAnimation : Snippet
slideInAnimation =
    -- TODO: This below is a very hacky way of adding keyframes, waiting for elm-css to add support for it
    selector "@keyframes slide-in {"
        [ descendants
            [ selector "0%"
                [ opacity (int 0)
                , property "} /*" ""
                ]
            , selector "*/ 10%"
                [ opacity (int 1)
                , transform (translateX (pct 150))
                , property "} /*" ""
                ]
            , selector "*/ to"
                [ transform (translateX (pct 0))
                , property "} /*" "*/"
                ]
            ]
        ]


desktopStyles : Snippet
desktopStyles =
    mediaQuery "(min-width: 1200px)"
        [ class Page centralizeContents
        , class Background
            [ maxHeight (px 680)
            , maxWidth (px 945)
            , boxShadow4 (em 0) (em 0.3) (em 1.2) (rgba 0 0 0 0.5)
            ]
        , class Container
            [ flexWrap wrap
            ]
        , class Icon
            [ display block
            , descendants
                [ selector ".material-icons"
                    [ fontSize (px 80)
                    ]
                ]
            ]
        , class Step
            [ width (pct 50)
            , height (pct 100)
            , descendants
                [ input
                    [ important <| borderBottom3 (px 1) solid primaryBlack
                    ]
                , label
                    [ important darkTextColor
                    ]
                , class Button
                    [ width (pct 100)
                    , darkTextColor
                    ]
                , class SubmitButton
                    [ backgroundColor primaryBlue
                    , lightTextColor
                    , hover
                        [ backgroundColor lighterBlue
                        ]
                    ]
                ]
            ]
        , class StepTitle centralizeContents
        , class StepForm
            [ backgroundColor (rgb 255 255 255)
            , darkTextColor
            , justifyContent spaceAround
            ]
        ]


centralizeContents : List Mixin
centralizeContents =
    [ displayFlex
    , alignItems center
    , justifyContent center
    ]
