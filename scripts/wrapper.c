  int
  main (int argc, char *argv[])
  {
     setuid (0);

     /* WARNING: Only use an absolute path to the script to execute,
      *          a malicious user might fool the binary and execute
      *          arbitary commands if not.
      * */

     system ("/bin/sh /var/www/scripts/staticWPtoGH.sh");

     return 0;
   }
