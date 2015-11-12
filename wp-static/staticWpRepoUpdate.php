<?php 

$wwwPATH = __DIR__  ;
$scriptLocation = "/../../scripts/wrap-static-repo-update";
$scriptPATH = $wwwPATH . $scriptLocation ;

echo "</br>";
echo "</br>";
echo $scriptPATH;
echo "</br>";
echo "</br>";


$updateRepo = shell_exec($scriptPATH);
var_dump($updateRepo);



?>