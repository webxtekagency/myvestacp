<?php

// Preventing CSRF
if ($_SERVER['REQUEST_METHOD']=='POST') {
    $host_arr=explode(":", $_SERVER['HTTP_HOST']);
    $hostname=$host_arr[0];
    $port = $_SERVER['SERVER_PORT'];
    $expected_http_origin="https://".$hostname.":".$port;
    if ($_SERVER['HTTP_ORIGIN'] != $expected_http_origin) {
        die ("Nope.");
    }
}

// Init
error_reporting(NULL);
ob_start();
session_start();
include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

$v_username = escapeshellarg($user);
exec (VESTA_CMD."v-schedule-user-backup ".$v_username, $output, $return_var);
if ($return_var == 0) {
    $_SESSION['error_msg'] = __('BACKUP_SCHEDULED');
} else {
    $_SESSION['error_msg'] = implode('<br>', $output);
    if (empty($_SESSION['error_msg'])) {
        $_SESSION['error_msg'] = __('Error: vesta did not return any output.');
    }

    if ($return_var == 4) {
        $_SESSION['error_msg'] = __('BACKUP_EXISTS');
    }

}
unset($output);
header("Location: /list/backup/");
exit;
