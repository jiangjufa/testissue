: "${keyuser:=root}"

program_path="$0"
usage() {
    export PROGNAME="${program_path##*/}"
    export PROGPADD="${PROGNAME//?/ }"
    export PROGPADD
    (echo "cat <<EOT"
     sed -n 's/^## \?//p' < "${program_path}"
     echo "EOT") > /tmp/.help.$$ ; . /tmp/.help.$$ ; rm /tmp/.help.$$
}

# Parse command line options:
while [ "$#" -gt 0 ] ; do
    case "$1" in
        -u|--user) keyuser="$2" ; shift 2 ;;
        -h|--help) usage ; exit 0 ;;
        -*) echo "Error: Unknown option '$1'." 1>&2 ; usage ; exit 1 ;;
        *) break ;;
    esac
done

userhome=$(awk -F: "\$1==\"${keyuser}\" { print \$6 }" /aix/etc/passwd)

for key in "$@" ; do
    echo "Adding SSH key '${key}' to ${userhome}."
    [ -d "/aix/${keyuser}/.ssh" ] || mkdir -p "/aix/${userhome}/.ssh "
    echo "${key}" >> "/aix/${userhome}/.ssh/authorized_keys"
done
