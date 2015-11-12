#!/bin/bash

###
# vars to change
###
absPATH="/var/www"
wpPATH="$absPATH/wordpress" # folder where current wordpress files are located ; e.g. wordpress -> /var/www/wordpress and the script is being ran in /var/www/script
productionPATH="$absPATH/wordpress/statictest" # folder where the static output will be copied to and parsed
wpTHEME="focused" # theme currently used

OLDDOMAIN="http://192.168.122.104/" # must end with trailing / # where does the current wordpress reside now # vm ip
NEWDOMAIN="http://yourdomain.tld/" # must end with trailing / # where will the static output be delivered to as domain #NEWDOMAIN="http://192.168.122.209/statictest/"

OLDDOMAINSHORT="192.168.122.104"
NEWDOMAINSHORT="yourdomain.tld"

###
# rewrite vars
###

OLDMAINURL="$OLDDOMAIN"wp-content/plugins/really-static/static/
NEWMAINURL=$NEWDOMAIN

OLDTHEMEURL="$OLDDOMAIN"wp-content/themes/
NEWTHEMEURL="$NEWMAINURL"includes/

OLDWPINCLUDESURL="$OLDDOMAIN"wp-includes/
NEWWPINCLUDESURL="$NEWMAINURL"includes/

OLDPLUGINSURL="$OLDDOMAIN"wp-content/plugins/
NEWPLUGINSURL="$NEWMAINURL"includes/

OLDUPLOADSURL="$OLDDOMAIN"wp-content/uploads/
NEWUPLOADSURL="$OLDDOMAIN"upload/

###
# git vars
###
DOMAIN="yourdomain.tld"
GHREPO=$DOMAIN
GHUSER="yourusername"
GHURL="git@github.com:$GHUSER/$GHREPO.git"
GHTOKEN="yourtoken"

###
# ssh vars
###
SSHHOST="webhost" # the ssh host defined in your ssh config
SSHPATH="/var/www/" 
SSHDEST=$SSHHOST:$SSHPATH

TODAY=$(date +%y-%m-%d-%R)

###
# git magic
###

gitCreateRepo () {
	echo "Creating repoistory named $DOMAIN"
	echo ""
	curl -i -H "Authorization: token $GHTOKEN" -d '{ "name": "'$DOMAIN'", "auto_init": false, "private": false, "itignore_template": "nanoc"  }' https://api.github.com/user/repos
}

gitRepoInit () {
	# make cname file for domain redirection
	echo $DOMAIN > CNAME
	echo "Initializing repository ... "
	git init
	git add *
	echo "Making first commit ... "
	git commit -m "first commit" 
	git remote add origin $GHURL
	echo "Changing branch ... "
	git branch gh-pages
	git checkout gh-pages
	echo "Pushing to upstream "
	git push -u origin gh-pages
}

gitRepoUpdate () {
	# http://stackoverflow.com/questions/492558/removing-multiple-files-from-a-git-repo-that-have-already-been-deleted-from-disk
	#cd $productionPATH
	#git add *
	git add *
	git add -u :/
	echo "Commiting"
	git commit -m "commited on - $TODAY" # add date ?  
	echo "Pushing to upstream "
	git push -u origin gh-pages
}

###
# update core website files
##

updateStaticContent () {
	mkdir -p $productionPATH
	echo "Copying static files "
	echo "rsync -avz $wpPATH/wp-content/plugins/really-static/static/* $productionPATH/ --delete" 
	#rsync -avz $wpPATH/wp-content/plugins/really-static/static/* $productionPATH/ --delete
	rsync -avz $wpPATH/wp-content/plugins/really-static/static/ $productionPATH --delete
	echo ""
}

#updateRootFolder () {
	# copy robots.txt , sitemap.xml, sitemap.xml.gz, googleBLABLA.html, favicon.ico
	# copy folders - resources, files , tools	
#}

###
# copy to same locations 
##


updateThemeFilesSame () {
	mkdir -p "$productionPATH/wp-content"
	echo "Copying theme files "
	echo "rsync -avz $wpPATH/wp-content/themes/$wpTHEME $productionPATH/wp-content/themes"
	rsync -avz $wpPATH/wp-content/themes/$wpTHEME $productionPATH/wp-content/themes # themes
	echo ""	
	# deleting all file types except the ones mentioned
	echo "Deleting everything but js, css, and images"
	find $productionPATH/wp-content/themes/$wpTHEME -maxdepth 3 -type f ! \( -iname '*.css' -o -iname '*.js' -o -iname '*.png'  -o -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.bmp' -o -iname '*.gif'  \) -delete
	echo ""
}

updateIncludesFilesSame () {
	mkdir -p "$productionPATH/wp-content"
	echo "Copying include files "
	echo "rsync -avz $wpPATH/wp-includes/js $productionPATH/wp-includes"
	rsync -avz $wpPATH/wp-includes/js $productionPATH/wp-includes # includes
	echo ""	
	echo "Deleting everything but js, css, and images"
	find $productionPATH/wp-includes -maxdepth 3 -type f ! \( -iname '*.css' -o -iname '*.js' -o -iname '*.png'  -o -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.bmp' -o -iname '*.gif'  \) -delete
	echo ""	
}

updateUploadsFilesSame () {
	mkdir -p "$productionPATH/wp-content"
	echo "Copying uploads files "
	echo "rsync -avz $wpPATH/wp-content/uploads $productionPATH/wp-content"
	rsync -avz $wpPATH/wp-content/uploads $productionPATH/wp-content # uploads
	echo ""	
}

updatePluginsFilesSame () {
	mkdir -p $productionPATH
	echo "Copying plugins files "
	echo "rsync -avz $wpPATH/wp-content/plugins/disqus-comment-system $productionPATH/wp-content/plugins"
	rsync -avz $wpPATH/wp-content/plugins/disqus-comment-system $productionPATH/wp-content/plugins
	echo ""	
}

deleteSedFiles () {
	echo "Deleting files created by sed"
	find $productionPATH -name "sed*" -type f
	find $productionPATH -name "sed*" -type f -delete	
	echo ""
}

###
# copy to different locations - requires rewirting
##

updateThemeFiles () {
	mkdir -p $productionPATH
	echo "Copying theme files "
	echo "rsync -avz $wpPATH/wp-content/themes/$wpTHEME $productionPATH/includes"
	rsync -avz $wpPATH/wp-content/themes/$wpTHEME $productionPATH/includes # themes
	echo ""	
	# deleting all file types except the ones mentioned
	find $productionPATH/includes/$wpTHEME -maxdepth 3 -type f ! \( -iname '*.css' -o -iname '*.js' -o -iname '*.png'  -o -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.bmp'  -o -iname '*.gif' \) -delete
}

updateIncludesFiles () {
	mkdir -p $productionPATH
	echo "Copying include files "
	echo "rsync -avz $wpPATH/wp-includes/js $productionPATH/includes"
	rsync -avz $wpPATH/wp-includes/js $productionPATH/includes # includes
	echo ""	
}

updateUploadsFiles () {
	mkdir -p $productionPATH
	echo "Copying uploads files "
	echo "rsync -avz $wpPATH/wp-content/uploads/* $productionPATH/upload/"
	rsync -avz $wpPATH/wp-content/uploads/* $productionPATH/upload/ # uploads
	echo ""	
}

###
# rewriting domain, urls and paths
# issue with sed - outputs empty files - "sed12314" after operations using the -i parameter without specifying different files for output and input
# https://www.daniweb.com/programming/software-development/threads/82822/sed-leaves-file-empty
###

rewriteDomain () {
	echo " Rewriting old domain to new one "
	echo  ''' grep -l -R -e "$OLDMAINURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|" '''
	grep -l -R -e "$OLDDOMAINSHORT" $productionPATH/* | xargs -n1 sed -i "s|$OLDDOMAINSHORT|$NEWDOMAINSHORT|"
	echo  ''' grep -l -R -e "$OLDMAINURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|" '''
	grep -l -R -e "$OLDDOMAINSHORT" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDDOMAINSHORT|$NEWDOMAINSHORT|"
	echo " Deleting files created by sed "
	find $wpPATH -name "sed*" -type f -delete
}

rewriteMainUrl () {
		# rewrite main url in root
	echo " Rewriting old ulrl to new one "
	echo  ''' grep -l -R -e "$OLDMAINURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|" '''
	grep -l -R -e "$OLDMAINURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|"
	echo  ''' grep -l -R -e "$OLDMAINURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|" '''
	grep -l -R -e "$OLDMAINURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|"
	echo " Deleting files created by sed "
	find $wpPATH -name "sed*" -type f -delete
	#echo " Rewriting old ulrl to new one "
	#echo  ''' grep -l -R -e "$OLDMAINURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|" '''
	#grep -l -R -e "$OLDMAINURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDMAINURL|$NEWMAINURL|"
	#echo ""	
}

rewriteThemeUrl () {
		# rewrite themes 
	echo " Rewriting wp-content/themes "
	echo  ''' grep -l -R -e "$OLDTHEMEURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDTHEMEURL|$NEWTHEMEURL|" '''
	grep -l -R -e "$OLDTHEMEURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDTHEMEURL|$NEWTHEMEURL|"
	echo  ''' grep -l -R -e "$OLDTHEMEURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDTHEMEURL|$NEWTHEMEURL|" '''
	grep -l -R -e "$OLDTHEMEURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDTHEMEURL|$NEWTHEMEURL|"
	echo ""	
}

rewriteUploadsUrl () {
	echo " Rewriting wp-uploads"
	echo  ''' grep -l -R -e "$OLDTHEMEURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDTHEMEURL|$NEWTHEMEURL|" '''
	grep -l -R -e "$OLDUPLOADSURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDUPLOADSURL|$NEWUPLOADSURL|"
	echo  ''' grep -l -R -e "$OLDTHEMEURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDTHEMEURL|$NEWTHEMEURL|" '''
	grep -l -R -e "$OLDUPLOADSURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDUPLOADSURL|$NEWUPLOADSURL|"
	echo ""	
}

rewriteIncludesUrl () {
	echo " Rewriting wp-includes "
	echo  ''' grep -l -R -e "$OLDWPINCLUDESURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDWPINCLUDESURL|$NEWWPINCLUDESURL|" '''
	grep -l -R -e "$OLDWPINCLUDESURL" $productionPATH/* | xargs -n1 sed -i "s|$OLDWPINCLUDESURL|$NEWWPINCLUDESURL|" 
	echo  ''' grep -l -R -e "$OLDWPINCLUDESURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDWPINCLUDESURL|$NEWWPINCLUDESURL|" '''
	grep -l -R -e "$OLDWPINCLUDESURL" $productionPATH/*/* | xargs -n1 sed -i "s|$OLDWPINCLUDESURL|$NEWWPINCLUDESURL|"
	echo ""	
}

uploadSSH () {
	rsync -azv --progress $productionPATH/ $SSHDEST --delete
	#touch testfile
	#rsync -azv --progress testfile $SSHDEST
	#rm testfile
}

if [ -z $1 ] #if the first parameter does not exist
then
	exit 1
fi

if [ $1 = "init" ] #if the first parameter is X
then
	# copy  static files from really-static folder to our manipulation/production folder
updateStaticContent

# copy theme files from wp-content to productionfolder in includes
	updateThemeFiles
	
# copy included files from wp-includes
	updateIncludesFiles
	
# rewrite wp-includes to includes
	rewriteIncludesUrl
	
	cd $productionPATH
	
# create repo via gh api 
	gitCreateRepo
	
# initialize github repo
	gitRepoInit
	
# add files to repo
	gitRepoUpdate
fi

if [ $1 = "update" ] #if the first parameter is X
then
	updateStaticContent
	#updateIncludesFiles
	#cd $productionPATH
	#gitRepoUpdate
	
fi

if [ $1 = "offtest" ] #if the first parameter is X
then
	updateStaticContent
	#updateThemeFiles
	updateIncludesFiles
	rewriteIncludesUrl
	
fi

if [ $1 = "theme" ] #if the first parameter is X
then
	updateThemeFilesSame
fi

if [ $1 = "ssh" ] #if the first parameter is X
then
	uploadSSH
fi

if [ $1 = "uploads" ] #if the first parameter is X
then
	updateUploadsFiles
	#rewriteUploadsUrl
fi

if [ $1 = "staticupdate" ] #if the first parameter is X
then
	updateStaticContent
	#read MORENA
	updateThemeFilesSame
	updateIncludesFilesSame
	updateUploadsFilesSame
	updatePluginsFilesSame
	rewriteMainUrl
	rewriteDomain
	deleteSedFiles
fi

if [ $1 = "repoinit" ] #if the first parameter is X
then
	cd $productionPATH
	gitCreateRepo
	gitRepoInit
fi

if [ $1 = "repoupdate" ] #if the first parameter is X
then
	cd $productionPATH
	gitRepoUpdate
fi

if [ $1 = "emptytest" ] #if the first parameter is X
then
	echo "ook it works mane"
fi