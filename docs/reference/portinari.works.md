# Paintings behind the Portinari palettes

The works each palette was drawn from, with links to the collection
pages. The sequential palettes `guerra_azul` and `paz_ouro` are derived
from `guerra` and `paz` and share their works.

## Usage

``` r
portinari.works(palette = NULL)
```

## Arguments

- palette:

  Optional character vector of palette names to filter by.

## Value

A data frame with columns `palette`, `title`, `year`, `collection`,
`inventory`, `url` (collection or story page) and `image_url` (the
museum's image, where one is published; `NA` otherwise).

## Examples

``` r
portinari.works()
#>       palette
#> 1        cafe
#> 2        cafe
#> 3  retirantes
#> 4  retirantes
#> 5  retirantes
#> 6  retirantes
#> 7        inah
#> 8       sofia
#> 9      guerra
#> 10        paz
#> 11 terra_roxa
#> 12 terra_roxa
#>                                                                   title
#> 1                                            Coffee Agricultural Worker
#> 2                                                         Saint Francis
#> 3                        Northeastern Migrants, from the Migrant Series
#> 4                                   Dead Child, from the Migrant Series
#> 5  Bust of the Poet Felippe Daudt d'Oliveira, from the Portraits Series
#> 6                           Mr. Queiroz Lima, from the Portraits Series
#> 7        Portrait of Ináh Prudente de Moraes, from the Portraits Series
#> 8                                           Portrait of Sofia Cantalupo
#> 9                                                          Guerra (War)
#> 10                                                          Paz (Peace)
#> 11                                           Coffee Agricultural Worker
#> 12                          Mr. Queiroz Lima, from the Portraits Series
#>         year                            collection  inventory
#> 1       1934                       MASP, São Paulo MASP.00519
#> 2       1941                       MASP, São Paulo MASP.00321
#> 3       1944                       MASP, São Paulo MASP.00324
#> 4       1944                       MASP, São Paulo MASP.00326
#> 5       1933                       MASP, São Paulo MASP.00568
#> 6       1934                       MASP, São Paulo MASP.00323
#> 7       1936                       MASP, São Paulo MASP.01295
#> 8       1936                       MASP, São Paulo MASP.01643
#> 9  1952–1956 United Nations Headquarters, New York       <NA>
#> 10 1952–1956 United Nations Headquarters, New York       <NA>
#> 11      1934                       MASP, São Paulo MASP.00519
#> 12      1934                       MASP, São Paulo MASP.00323
#>                                                                                                            url
#> 1                                          https://masp.org.br/en/collections/works/coffee-agricultural-worker
#> 2                                                       https://masp.org.br/en/collections/works/saint-francis
#> 3             https://masp.org.br/en/collections/works/northeastern-migrants-from-the-migrant-series-1944-1945
#> 4                        https://masp.org.br/en/collections/works/dead-child-from-the-migrant-series-1944-1945
#> 5  https://masp.org.br/en/collections/works/bust-of-the-poet-felippe-daudt-doliveira-from-the-portraits-series
#> 6                           https://masp.org.br/en/collections/works/mr-queiroz-lima-from-the-portraits-series
#> 7       https://masp.org.br/en/collections/works/portrait-of-inah-prudente-de-moraes-from-the-portraits-series
#> 8                                         https://masp.org.br/en/collections/works/portrait-of-sofia-cantalupo
#> 9                                         https://artsandculture.google.com/story/war-1952-1956/IQLSaZmD0m7gIQ
#> 10                                      https://artsandculture.google.com/story/peace-1952-1956/PAKykLKUPJ4aKw
#> 11                                         https://masp.org.br/en/collections/works/coffee-agricultural-worker
#> 12                          https://masp.org.br/en/collections/works/mr-queiroz-lima-from-the-portraits-series
#>                                                              image_url
#> 1     https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00519_01.jpg
#> 2     https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00321_01.jpg
#> 3  https://assets.masp.org.br/uploads/temp/WEB_IFUSP_MASP_00324_01.jpg
#> 4  https://assets.masp.org.br/uploads/temp/WEB_IFUSP_MASP_00326_01.jpg
#> 5     https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00568_01.jpg
#> 6     https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00323_01.jpg
#> 7     https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_01295_01.jpg
#> 8     https://assets.masp.org.br/uploads/temp/WEB_JB_MASP_01643_01.jpg
#> 9                                                                 <NA>
#> 10                                                                <NA>
#> 11    https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00519_01.jpg
#> 12    https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00323_01.jpg
portinari.works("retirantes")
#>      palette
#> 3 retirantes
#> 4 retirantes
#> 5 retirantes
#> 6 retirantes
#>                                                                  title year
#> 3                       Northeastern Migrants, from the Migrant Series 1944
#> 4                                  Dead Child, from the Migrant Series 1944
#> 5 Bust of the Poet Felippe Daudt d'Oliveira, from the Portraits Series 1933
#> 6                          Mr. Queiroz Lima, from the Portraits Series 1934
#>        collection  inventory
#> 3 MASP, São Paulo MASP.00324
#> 4 MASP, São Paulo MASP.00326
#> 5 MASP, São Paulo MASP.00568
#> 6 MASP, São Paulo MASP.00323
#>                                                                                                           url
#> 3            https://masp.org.br/en/collections/works/northeastern-migrants-from-the-migrant-series-1944-1945
#> 4                       https://masp.org.br/en/collections/works/dead-child-from-the-migrant-series-1944-1945
#> 5 https://masp.org.br/en/collections/works/bust-of-the-poet-felippe-daudt-doliveira-from-the-portraits-series
#> 6                          https://masp.org.br/en/collections/works/mr-queiroz-lima-from-the-portraits-series
#>                                                             image_url
#> 3 https://assets.masp.org.br/uploads/temp/WEB_IFUSP_MASP_00324_01.jpg
#> 4 https://assets.masp.org.br/uploads/temp/WEB_IFUSP_MASP_00326_01.jpg
#> 5    https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00568_01.jpg
#> 6    https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00323_01.jpg
```
