<?php 

/*
 * https://codex.wordpress.org/Administration_Menus
 * http://www.paulund.co.uk/add-menu-item-to-wordpress-admin
 * 
 */

function theme_options_panel(){
  add_menu_page('staticWPtoGH', 'staticWPtoGH', 'manage_options', 'theme-options', 'wps_theme_func');
  add_submenu_page( 'theme-options', 'Test', 'test', 'manage_options', 'theme-op-test', 'wps_theme_func_test');
  add_submenu_page( 'theme-options', 'Update repo', 'Update repo', 'manage_options', 'theme-op-uprepo', 'wps_theme_func_uprepo');
  add_submenu_page( 'theme-options', 'Update ssh', 'Update ssh', 'manage_options', 'theme-op-upssh', 'wps_theme_func_upssh');
  add_submenu_page( 'theme-options', 'Update files', 'Update files', 'manage_options', 'theme-op-upfiles', 'wps_theme_func_upfiles');
}

add_action('admin_menu', 'theme_options_panel');

function wps_theme_func(){
                include 'wp-static/menu.html';
}

function wps_theme_func_test(){
	echo '<div class="wrap"><div id="icon-options-general" class="icon32"><br></div>
                <h2>test</h2></div>';
	echo __DIR__;
	//* include "__DIR__/updatestatic.php" ;
	echo "</br></br>";
	include 'wp-static/staticWpTest.php';
}

function wps_theme_func_uprepo(){
                echo '<div class="wrap"><div id="icon-options-general" class="icon32"><br></div>
                <h2>Update repo</h2></div>';
                echo __DIR__;
                //* include "__DIR__/updatestatic.php" ; 
                echo "</br></br>";
                include 'wp-static/staticWpRepoUpdate.php';
}

function wps_theme_func_upssh(){
	echo '<div class="wrap"><div id="icon-options-general" class="icon32"><br></div>
                <h2>Update ssh</h2></div>';
	echo __DIR__;
	//* include "__DIR__/updatestatic.php" ;
	echo "</br></br>";
	include 'wp-static/staticWpSshUpdate.php';
}

function wps_theme_func_upfiles(){
                echo '<div class="wrap"><div id="icon-options-general" class="icon32"><br></div>
                <h2>Static update</h2></div>';
                echo __DIR__;
                //* include "__DIR__/updatestatic.php" ; 
                echo "</br></br>";
                include 'wp-static/staticWpFilesUpdate.php';
}













?>