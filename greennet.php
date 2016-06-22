<?php
include 'aes.php';

$action = $_GET["action"];

if($action == "register")
{
    $domain = $_GET["domain"];

    if(!file_exists("domains/".$domain))
    {
        date_default_timezone_set("ETC");

        mkdir("domains/".$domain);

        $file = fopen("domains/".$domain."/accountData.json", "w");

        $shaKey = hash("sha224", $_GET["password"]);

        $raw = new AES($_GET["password"], $shaKey, 256);

        $encryption = $raw->encrypt();

        $toAppend = array("password" => $encryption, "data" => "Date-".date("Y-m-d"), "time-" => "unix-epoch-ETC-".time());

        fwrite($file, json_encode($toAppend));

        fclose($file);
    }
}