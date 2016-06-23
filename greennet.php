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

        mkdir("domains/".$domain."/requests");

        mkdir("domains/".$domain."/subDomains");

        $file = fopen("domains/".$domain."/accountData.json", "w");

        $shaKey = hash("sha224", $_GET["password"]);

        $raw = new AES($_GET["password"], $shaKey, 256);

        $encryption = $raw->encrypt();

        $toAppend = array("password" => $encryption, "date" => date("Y-m-d"), "time-" => "unix-epoch-ETC-".time());

        fwrite($file, json_encode($toAppend));

        fclose($file);

        echo "true";
    } else {
        echo "domain exists";
    }
} else if($action == "registerSubdomain")
{
    $domain = $_GET["domain"];
    $sub = $_GET["subDomain"];
    if(file_exists("domains/".$domain) && !file_exists("domains/".$domain."/subDomains"."/".$sub))
    {
        $rshaKey = hash("sha224", $_GET["rootpassword"]);

        $file = fopen("domains/".$domain."/accountData.json", "r");

        $arr = json_decode(fread($file, filesize("domains/".$domain."/accountData.json")));

        fclose($file);

        $rraw = new AES($arr->{'password'}, $rshaKey, 256);

        $mainpassword = $rraw->decrypt();

        if($mainpassword == $_GET["rootpassword"])
        {
            date_default_timezone_set("ETC");

            mkdir("domains/".$domain."/subDomains"."/".$sub);

            mkdir("domains/".$domain."/subDomains"."/".$sub."/requests");

            $shaKey = hash("sha224", $_GET["password"]);

            $raw = new AES($_GET["password"], $shaKey, 256);

            $encryption = $raw->encrypt();

            $toAppend = array("password" => $encryption, "date" => date("Y-m-d"), "time-" => "unix-epoch-ETC-".time());

            $file = fopen("domains/".$domain."/subDomains"."/".$sub."/accountData.json", "w");

            fwrite($file, json_encode($toAppend));

            fclose($file);

            echo "true";
        } else {
            echo "false";
        }
    } else {
        echo "non existing domain or existing subdomain";
    }
}