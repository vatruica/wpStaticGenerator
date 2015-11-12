<?php 

$wwwPATH = __DIR__  ;
$scriptLocation = "/../../scripts/wrap-static-ssh-update";
$scriptPATH = $wwwPATH . $scriptLocation ;

echo "</br>";
echo "</br>";
echo $scriptPATH;
echo "</br>";
echo "</br>";


$updateSsh = shell_exec($scriptPATH);
var_dump($updateSsh);



?>