# $!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
function print_message(){
    if [$# -eq 0]; then
        echo "Usage print_message MESSAGE [RULE_CHARACTER]"
        return 1
    fi
    printf -v _hr "%*s" $(tput cols) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}
#------------------------------------------------------------------------------------------------------------
function destroy_docker(){
    docker kill jenkins
    docker rm jenkins
}
#------------------------------------------------------------------------------------------------------------
function setup_docker(){
    echo "Building test jenkins and seeding it"
    docker build -t jenkins .
    run_test_container
}

#------------------------------------------------------------------------------------------------------------
function run_test_container(){
    IMAGE_TO_RUN="jenkins"
    echo "Running: docker run --name $IMAGE_TO_RUN -p 8080:8080 -v /var/jenkins_home $IMAGE_TO_RUN &"
    docker run -d --name $IMAGE_TO_RUN -p 8080:8080 -v /var/jenkins_home $IMAGE_TO_RUN 
    sleep 30
    curl -X POST http://admin:admin@localhost:8080/job/bootstrap/build
}

#------------------------------------------------------------------------------------------------------------
function rebuild(){
    destroy_docker
    setup_docker
}

#------------------------------------------------------------------------------------------------------------
### MAIN
#------------------------------------------------------------------------------------------------------------
CMD=
while getopts bdr opts; do
    case ${opts} in
        b) CMD="BUILD" ;;
        d) CMD="DESTROY" ;;
        r) CMD="REBUILD" ;;
        *) print_usage ; exit 0;;
        \? | h | *) print_usage ; exit 0;;
        :) print_usage ; exit 0;;
    esac
done
shift $((OPTIND-1))

echo $GRUNT_CMD
if [ -n "$CMD" ]; then
    case ${CMD} in
        BUILD) setup_docker ;;
        DESTROY) destroy_docker ;;
        REBUILD) rebuild ;;
    esac
else
    # Default set up if nothing called
    setup_docker 
fi
