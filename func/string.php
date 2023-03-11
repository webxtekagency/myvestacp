<?php

function myvesta_replace_in_file($find, $replace, $file) {
    if (!file_exists($file)) return myvesta_throw_error (MYVESTA_ERROR_FILE_DOES_NOT_EXISTS, "File '$file' not found");

    $buf=file_get_contents($file);

    if (strpos($buf, $find)===false) return myvesta_throw_error (MYVESTA_ERROR_STRING_NOT_FOUND, "String '$find' not found");

    $buf=str_replace($find, $replace, $buf);
    $r=file_put_contents($file, $buf);
    return $r;
}

function myvesta_str_get_between (&$text, $left_substring, $right_substring, $start=0, $do_not_return_left_substring=1, $do_not_return_right_substring=1, $left_substring_necessary=1, $right_substring_necessary=1)
{
	$from_null=0;
	$pos1=strpos($text, $left_substring, $start);
	if ($pos1===FALSE)
	{
		if ($left_substring_necessary==1) return "";
		$pos1=$start;
		$from_null=1;
	}

	if ($do_not_return_left_substring==1)
	{
		if ($from_null==0) $pos1=$pos1+strlen($left_substring);
	}
	$pos2=strpos($text, $right_substring, $pos1+1);
	if ($pos2===FALSE)
	{
		if ($right_substring_necessary==1) return "";
		$pos2=strlen($text);
	}
	if ($do_not_return_right_substring==1) $len=$pos2-$pos1;
	else $len=($pos2-$pos1)+strlen($right_substring);
	
	$slen=strlen($text);
	if ($pos1+$len>$slen) $len=$slen-$pos1;
	
	return substr($text, $pos1, $len);
}
