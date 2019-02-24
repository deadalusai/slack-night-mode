npm install sass

$SASS_EXE = Resolve-Path '.\node_modules\.bin\sass.cmd'

# default:
& $SASS_EXE --style compressed scss/main.scss css/black.css

# raw:
& $SASS_EXE --style compressed scss/styles.scss css/raw/black.css

# variants:
foreach ($Sass in (ls '.\scss\themes\build-variants\*--main.scss')) {
    $Theme = [System.IO.Path]::GetFileNameWithoutExtension($Sass).Replace('--main', '')
    & $SASS_EXE --style compressed $Sass "css/variants/$Theme.css"
}

# rawvariants:
foreach ($Sass in (ls '.\scss\themes\build-variants\*--styles.scss')) {
    $Theme = [System.IO.Path]::GetFileNameWithoutExtension($Sass).Replace('--styles', '')
    & $SASS_EXE --style compressed $Sass "css/raw/variants/$Theme.css"
}