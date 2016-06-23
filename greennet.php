<?php
include 'aes.php';

//error_reporting(0);

$action = $_GET["action"];

function encryptionToPassword($encryption, $password)
{
    $shaKey = hash("sha224", $password);

    $aes = new AES($encryption, $shaKey, 256);

    $password = $aes->decrypt();

    return $password;
}

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

        $toAppend = array("password" => $encryption, "date" => date("Y-m-d"), "time" => time());

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

            $toAppend = array("password" => $encryption, "date" => date("Y-m-d"), "time" => time());

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
} else if($action == "generateNewSession")
{
    $password = $_GET["password"];

    $domain = $_GET["domain"];

    $subDomain = $_GET["subDomain"]; //--Not requred--//
    
    if(file_exists("domains/".$domain))
    {
        if($subDomain != null)
        {
            if(file_exists("domains/".$domain."/subDomains"."/".$subDomain))
            {
                $file = fopen("domains/".$domain."/subDomains"."/".$subDomain."/accountData.json", "r");

                $rawJSON = fread($file, filesize("domains/".$domain."/subDomains"."/".$subDomain."/accountData.json"));

                fclose($file);

                $json = json_decode($rawJSON);

                if(encryptionToPassword($json->{'password'}, $password); == $password)
                {
                    $file = fopen("domains/".$domain."/subDomains"."/".$subDomain."/sessionData.json", "w");

                    $sessionID = rand(1000, 9999)."-".rand(1000, 9999);

                    $toAppend = array("currentSession" => $sessionID, "date" => date("Y-m-d"), "time" => time());

                    fwrite($file, json_encode($toAppend));

                    fclose($file);

                    echo "true";
                } else
                {
                    echo "invalid password";
                }
            } else
            {
                echo "no such subdomain";
            }
        } else
        {
            if(file_exists("domains/".$domain))
            {
                $file = fopen("domains/".$domain."/accountData.json", "r");

                $rawJSON = fread($file, filesize("domains/".$domain."/accountData.json"));

                fclose($file);

                $json = json_decode($rawJSON);

                if(encryptionToPassword($json->{'password'}, $password); == $password)
                {
                    $file = fopen("domains/".$domain."/sessionData.json", "w");

                    $sessionID = rand(1000, 9999)."-".rand(1000, 9999);

                    $toAppend = array("currentSession" => $sessionID, "date" => date("Y-m-d"), "time" => time());

                    fwrite($file, json_encode($toAppend));

                    fclose($file);

                    echo "true";
                } else
                {
                    echo "invalid password";
                }
            } else
            {
                echo "no such domain";
            } 
        }
    }
}