<?php

namespace App\Http\Middleware;

use Illuminate\Http\Middleware\TrustProxies as Middleware;
use Symfony\Component\HttpFoundation\Request;

class TrustProxies extends Middleware
{
    /**
     * The trusted proxies for this application.
     */
    protected $proxies;

    /**
     * The headers that should be used to detect proxies.
     */
    protected $headers =
        Request::HEADER_X_FORWARDED_FOR |
        Request::HEADER_X_FORWARDED_HOST |
        Request::HEADER_X_FORWARDED_PORT |
        Request::HEADER_X_FORWARDED_PROTO |
        Request::HEADER_X_FORWARDED_AWS_ELB;

    public function __construct()
    {
        $this->proxies = $this->getProxiesFromConfig();
    }

    private function getProxiesFromConfig()
    {
        $proxies = config('proxies.trusted');

        if (!$proxies) {
            return null;
        }

        if ($proxies === '*') {
            return $proxies;
        }

        if (is_string($proxies)) {
            return array_map('trim', explode(',', $proxies));
        }

        return $proxies;
    }
}
