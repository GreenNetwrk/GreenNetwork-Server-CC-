<?php
$action = $_GET["action"];

if($action == "register")
{
    $domain = $_GET["domain"];
    if(!file_exists("domains/".$domain))
    {
        date_default_timezone_set("ETC");

        mkdir("domains/"..$domain);

        $file = fopen("domains/".$domain."accountData.json", "r");

        $toAppend = array("password" => $_GET["password"], "data" => "Date ".date("Y-m-d"), "time" => "unix epoch ETC".time());
    }
}