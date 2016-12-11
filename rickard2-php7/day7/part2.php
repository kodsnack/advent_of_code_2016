<?php

require 'lib.php';

$ipAddresses               = IpAddress::createFromFile('input');
$ipAddressesWithTLSSupport = array_filter($ipAddresses, function (IpAddress $ipAddress) {
    return $ipAddress->supportsSSL();
});

printf('There are %d IPs that supports SSL' . PHP_EOL, count($ipAddressesWithTLSSupport));