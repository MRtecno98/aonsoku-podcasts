<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Trusted Proxies
    |--------------------------------------------------------------------------
    | Define trusted proxies by IP or use '*' to trust all
    | Examples: '10.0.0.1,10.0.0.2' or '*'
    |
    */
    'trusted' => env('TRUSTED_PROXIES', null),
];
