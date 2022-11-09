#!/bin/bash

##################################
# usage: ./create-mail-sync.sh SRCHOST EMAIL PASSWORD-ON-REMOTE-SERVER [PASSWORD-ON-THIS-SERVER] [TEST]
##################################

if [ $# -lt 3 ]; then
    echo "usage: ./create-mail-sync.sh SRCHOST EMAIL PASSWORD-ON-REMOTE-SERVER [PASSWORD-ON-THIS-SERVER] [TEST]"
    exit 1
fi

if [ $# -eq 3 ]; then
SRCHOST=$1
EMAIL=$2
PASS=$3
PASS2=$3
TEST=1
fi

if [ $# -eq 4 ]; then
SRCHOST=$1
EMAIL=$2
PASS=$3
PASS2=$4
TEST=1
fi

if [ $# -eq 5 ]; then
SRCHOST=$1
EMAIL=$2
PASS=$3
PASS2=$4
TEST=$5
fi

TESTOPT=""
if [[ $TEST -eq 1 ]]; then
	TESTOPT="--justlogin"
fi

if [ ! -d "accounts" ]; then
    mkdir accounts
fi
if [ -f "accounts/$EMAIL" ]; then
	echo "********* $EMAIL ALREADY EXISTS !!! ************"
    exit 1;
    exit
fi

echo "Writing to: accounts/$EMAIL"
echo "#!/bin/bash

# --- 
# SRCHOST = $SRCHOST
# email   = $EMAIL
# pass    = $PASS
# pass2   = $PASS2
# test    = $TEST
# ---

/root/imapsync/imapsync --host1  $SRCHOST   --user1 $EMAIL   --password1 '$PASS' --ssl1 --host2 localhost   --user2 $EMAIL   --password2 '$PASS2' $TESTOPT --addheader  --automap \"\$@\"

exit;
# ---
" > accounts/$EMAIL

chmod a=rwx accounts/$EMAIL

if [[ $TEST -eq 0 ]]; then
	exit 0;
fi

accounts/$EMAIL
RET=$?

if [ $RET -eq 0 ]; then
	# echo "./create-mail-sync.sh $EMAIL $PASS $PASS2 $TEST"
	sed -i "s/--justlogin//g" accounts/$EMAIL
	echo "--- OK! ---"
	echo "./create-mail-sync.sh '$SRCHOST' '$EMAIL' '$PASS' '$PASS2' $TEST" >> accounts.log
else
	echo "********* $EMAIL ERROR !!! [ret: $RET ] ************"
	echo "********* $EMAIL ERROR !!! [ret: $RET ] ************"
	echo "********* $EMAIL ERROR !!! [ret: $RET ] ************"
	rm accounts/$EMAIL
fi
exit $RET;
