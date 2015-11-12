<?php 

$wwwPATH = __DIR__  ;
$scriptLocation = "/../../scripts/wrap-static-test";
$scriptPATH = $wwwPATH . $scriptLocation ;

echo "</br>";
echo "</br>";
echo $scriptPATH;
echo "</br>";
echo "</br>";


$test = shell_exec($scriptPATH);
var_dump($test);



?>