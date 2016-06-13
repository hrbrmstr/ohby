
`ohby` : R interface to the "ohby" URL / content shortener

Ref: <https://0x.co/hnfaq.html>

What is "oh by" ? What do I do here ?

"oh by" is a simple primitive that you can use to condense information.

It is, sort of, a combination of a pastebin-style site and a URL shortener.

The real utility are the easily recognizable codes, prefixed with "0x".

The following functions are implemented:

-   `shorten()` : um…shorten stuff
-   `expand()` : um…expand stuff

### Installation

``` r
devtools::install_github("hrbrmstr/ohby")
```

### Usage

``` r
library(ohby)

# current verison
packageVersion("ohby")
```

    ## [1] '0.1.0'

``` r
(one <- shorten("http://rud.is/b"))
```

    ## $code
    ## [1] "9XF4AG"
    ## 
    ## $url
    ## [1] "https://0x.co/9XF4AG"
    ## 
    ## $sha256
    ## [1] "2a2655348ef8121a550ca338ebcdf87ea1f5fa3a2fc7741755e9f2ba92e4b9b2"

``` r
(two <- shorten("The quick, brown fox jumps over the lazy dog"))
```

    ## $code
    ## [1] "53EMMZ"
    ## 
    ## $url
    ## [1] "https://0x.co/53EMMZ"
    ## 
    ## $sha256
    ## [1] "bbbe3327186bdc70f644f59d2501350bf5ea4127a6a2846dd2b3d002d2945754"

``` r
(expand(one$url))
```

    ## [1] "http://rud.is/b"

``` r
(expand(two$url))
```

    ## [1] "The quick, brown fox jumps over the lazy dog"

### Test Results

``` r
library(ohby)
library(testthat)

date()
```

    ## [1] "Mon Jun 13 16:44:07 2016"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
