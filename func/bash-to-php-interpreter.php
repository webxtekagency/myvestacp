<?php

$myvesta_echo_done=false;

if (isset($_SERVER['SHLVL'])) $SHLVL=intval($_SERVER['SHLVL']);
else $SHLVL=3;

if (!isset($argv)) exit(5);

stream_set_blocking(STDIN, false);
$myvesta_stdin='';
$myvesta_f = fopen( 'php://stdin', 'r' );
while( $myvesta_line = fgets( $myvesta_f ) ) {
  $myvesta_stdin .= $myvesta_line;
}
fclose( $myvesta_f );

include ("/usr/local/vesta/func/main.php");
include ("/usr/local/vesta/func/string.php");

$counter=count($argv);
if ($counter<2) myvesta_throw_error(2, 'Function is missing');

$func=$argv[1];
if (!function_exists($func)) {
    $func="myvesta_".$argv[1];    
    if (!function_exists($func)) myvesta_throw_error(2, 'Function does not exists');
}

$params=array();

if ($myvesta_stdin!='') $params[]=$myvesta_stdin;
for ($i=2; $i<$counter; $i++) {
    $argv[$i]=myvesta_fix_backslashes($argv[$i]);
    $params[]=$argv[$i];
}

$r=call_user_func_array($func, $params);
if (is_bool($r)) {
    if ($r) {
        myvesta_exit (0);
    } else {
        myvesta_exit (MYVESTA_ERROR_GENERAL);
    }
} else {
    myvesta_echo ($r);
    myvesta_exit (0);
}
