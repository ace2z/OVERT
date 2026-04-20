#!/bin/bash
# ▮▮▮ Ultimate Bash Script helper tools - 2025_0829  (set no_colors_flag to something to disable colors)
#!/bin/bash
CDIR=${PWD} CUSER=${USER} HOMED=${HOME} JUST_DIR=`basename ${CDIR}` TPUTBIN=`which tput` no_colors_flag=""
setCOL() { $TPUTBIN setaf $1; }
resetTERM() { $TPUTBIN sgr0; echo -en "\033[0m"; }  # Overkill using both, but guaranteed to work
NEWL() { echo ""; }
ECO() { if [[ $no_colors_flag == "" ]]; then $TPUTBIN setaf $1; else resetTERM; fi; echo -n "${2}"; resetTERM; if [[ -z $3 ]]; then echo ""; fi; } # pass nocr to skip CR
SLEEP() { stime=3; if [[ ! -z $1 ]]; then stime=$1; fi; NEWL; ECO 3 "  Sleeping for ${stime} seconds..."; NEWL; sleep $stime; }
# usage:  pressany "Are you Sure?" "YES"   or just: pressany, or pressany "whats your name" "||" (you'll be able to read the users response from $RESP)
RESP="" # Holds the user responses from pressany
pressany() { RESP=""; if [[ -z $1 ]]; then read -rsp "Press any Key to Continue"; echo ""; return; fi; if [[ ! -z $2 ]]; then if [[ $2 == "||" ]]; then ECO 11 "$1" nocr; setCOL 14; read -r RESP; return; fi; fi; ECO 13 "$1 ( " nocr; ECO 7 "require " nocr; ECO 11 "$2" nocr; ECO 13 " ): " nocr; read -r RESP; if [[ ! $RESP == "$2" ]]; then echo ""; ECO 13 "*** INVALID RESPONSE ***"; echo ""; exit -99; fi; }
# Safety handler for being in SYMLINKDIR
dir_is_symlink=0;currp=$(pwd);truesp=$(realpath "$currp");if [[ "$currp" != "$truesp" ]]; then dir_is_symlink=1;fi; if [ $dir_is_symlink -eq 1 ]; then NEWL; ECO 3 " •• WARNING: Currently in SYMLINK dir, TRUE source: " nocr; ECO 13 "$truesp"; ECO 14 " •• Switching to TRUE source";CDIR="$truesp"; cd "$truesp"; NEWL;fi
# ▮▮▮ end of helpers | 2=green,3=yellow,5=mag,6=cyan,7=white|BOLD: 9=red, 10=grn,11=yell,13=magen,14=CYAN,15=WHITE

# ▮▮▮
# ▮▮▮ TF Vars and core aliases
export TF_env2use=""  # This will contain the desired environment: DEV, QA, PROD, etc.
tmpTFP="TFPlan.tmp"
tmpTFDestroy="TFDestroyPlan.tmp"
TF_BACKEND_CFG=""
TF_APPSTACK_CONFIG=""
def_ERR_code=255
importMODE=0
valid_ENVLIST=(
    "sandbox"
    "dev"
    "qa"
    "uat"
    "prod"
)
alias cleanPlan="rm -f ${tmpTFP} 2>&1; rm -f ${tmpTFDestroy} 2>&1"
alias tfvalid="terraform validate"
alias tfmt="terraform fmt -recursive"

show_CommonERROR_MSG() {
    ECO $YELL "  You MUST run '" nocr
    ECO $CYAN "tfBackendINIT | tbe | tfp" nocr
    ECO $CYAN " [ " nocr
    ECO $WHITE "sandbox | dev | qa | uat | prod " nocr
    ECO $CYAN "]" nocr
    ECO $YELL "'"
    ECO $YELL "  to properly INIT the Terraform State, Backend ENVironment"
    echo ""
}
tfPURGE_CMD() {
    echo ""
    ECO $MAG "  ▮▮▮ Purge/Cleanup of any existing Terraform TMP files..."
    rm -rf .terraform 2>&1
    rm -f .terraform.lock.hcl 2>&1
    cleanPlan

    ECO $MAG "  ▮▮▮ " nocr
    ECO $CYAN "Purge Complete"

    # Now unless "skip" or something was passed? lets remind user to rerun tbe
    if [[ -z $1 ]]; then
        echo ""
        ECO $WHITE "  ▮▮▮ NOTE: " nocr
        show_CommonERROR_MSG
    fi
    echo ""
}
alias tfpurge="tfPURGE_CMD"

checkERR_Valid_ENVSET() {
    have_problem=0
    # Make sure environment is VALID (exists in valid_ENVLIST)
    if [[ -z $TF_env2use ]]; then
        have_problem=1
    else
        have_problem=1 #force to "problem" state. If a valid entry is found? this is reset to 0
        for item in "${valid_ENVLIST[@]}"; do
            if [[ "$item" == "$TF_env2use" ]]; then
                have_problem=0
                break
            fi
        done
    fi

    # If have_problem is 1, we need to show error
    if [[ $have_problem -eq 1 ]]; then
        echo ""
        show_CommonERROR_MSG
        return $def_ERR_code #effectively returns 'false' to the caller
    fi
    return 0 # explicitly returns TRUE
}

show_CMD_2run() {
    cmd2run=${1}
    echo ""
    ECO $YELL "  ▮▮▮ " nocr
    ECO $YELL "Will Execute CMD: "
    ECO $CYAN "    ${cmd2run}";
    echo ""
}
init_TFENV_Backend_STATE() {
    if [[ ! -z $1 ]]; then
        # Set and CHECK TF_env2use
        TF_env2use=$1       
        if ! checkERR_Valid_ENVSET; then
            return $def_ERR_code
        fi
    else
        show_CommonERROR_MSG
        return $def_ERR_code
    fi

    echo ""
    # proper way to init BACKEND State by ENV (NOTE: TF_APPSTACK_CONFIG is used by any terraform plans)
    TF_BACKEND_CFG="-backend-config=backend/backend.${TF_env2use}.tfvars -backend-config=cfg_APPSTACK_StateKey.tfvars"  
    TF_APPSTACK_CONFIG="-var-file=config/cfg.${TF_env2use}.tfvars -var-file=backend/backend.${TF_env2use}.tfvars -var-file=cfg_APPSTACK_StateKey.tfvars"

    # By default just do terraform init
    cmd2run="terraform init ${TF_BACKEND_CFG}"

    # However if user passed "reconfig" to $2
    if [[ ! -z $2 ]]; then
        if [[ "$2" == "reconfig"* ]]; then
            cmd2run="terraform init -reconfigure ${TF_BACKEND_CFG}"
            ECO $YELL "   *** " nocr
            ECO $WHITE "▮▮▮ RECONFIGURE to new BACKend ENV: " nocr 
        fi
    else
        tfpurge skipwarning
        ECO $YELL "  ▮▮▮ Initializing Terraform State BACKEND ENV to: " nocr
        
    fi

    # Additional User Feedback  
    ECO $CYAN "${TF_env2use}"
    show_CMD_2run "${cmd2run}"
    $cmd2run
}

quik_TF_EnvSet_or_SHOW() {
    
    if [[ ! -z $1 ]]; then
        TF_env2use="$1"
        init_TFENV_Backend_STATE
    fi
    echo ""
    ECO 3 " ▮▮▮ TERRAFORM Deploy ENV is: " nocr
    ECO 6 "${TF_env2use}"
    echo ""
}
quik_TFPlan() {
    echo ""
    #err handling
    if [[ -z $1 && -z $TF_env2use ]]; then
        show_CommonERROR_MSG
        return $def_ERR_code
    fi

    # !!! ALSO make sure they arent trying to tfp qa, if we are already INIT'd to DEV
    if [[ ! -z $TF_env2use && ! -z $1 ]]; then
        if [[ ! "$TF_env2use" == "${1}" ]]; then
            ECO 5 " ▮▮▮ ERROR: Invalid Attempt to Switch ENVSTATE"
            show_CommonERROR_MSG
            return $def_ERR_code
        fi
    fi

    # !!! check to see if TF_env2use is blank and user passed dev (or another VALID env):
    #     we automatically call init_TFENV_Backend_STATE first for them
    if [[ -z $TF_env2use && ! -z $1 ]]; then
        init_TFENV_Backend_STATE "$1"
    fi

    # !!! check for ENV error (make sure TF_env2use is SET, and is valid )
    if ! checkERR_Valid_ENVSET; then
        return $def_ERR_code
    fi

    # always clean any previous plans
    cleanPlan

    cmd2run="terraform plan ${TF_APPSTACK_CONFIG} -out=${tmpTFP}"
    # However, if we are in IMPORT mode? we have extra to do
    if [[ ! -z $2 ]]; then
        ECO 3 " ▮▮▮"
        ECO 3 " ▮▮▮ IMPORT MODE ▮▮▮"

        tstamp=`date +"%Y%m%d_%H%M"`
        output_file="TF_ImportGenerated_${tstamp}.tf"
        #output_file="generated.tf"

        cmd4IMPORT="terraform plan ${TF_APPSTACK_CONFIG} -generate-config-out=${output_file}"
        show_CMD_2run "$cmd4IMPORT"
        
        #IMPORTANT: run like this so each command suceeds before running next
        tfvalid && tfmt && $cmd4IMPORT && $cmd2run
        ls -ltr $output_file
        return
    fi
    
    # Normal user feedback for regular plans
    show_CMD_2run "$cmd2run"
    tfvalid && tfmt && $cmd2run 
}
quik_TFApply() {
    echo ""
    # !!! check for ENV error (make TF_env2use sure its set properly)
    if ! checkERR_Valid_ENVSET; then
        return $def_ERR_code
    fi

    cmd2run="terraform apply ${tmpTFP}"
    
    show_CMD_2run "$cmd2run"
    $cmd2run    
}

quik_TFImportPlan() {
    quik_TFPlan "$TF_env2use" "importmode"
}

# ▮▮▮
# ▮▮▮ Useful ALIASES
alias tfinit="tfpurge"
alias azloginCode="az login --use-device-code"

# NOTE: This is specifically for Azure
alias azlogin="az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}"

alias tfup="tfupgrade"
alias tfBackendINIT="init_TFENV_Backend_STATE"
alias tbe="tfBackendINIT"
alias tfinit="tfBackendINIT"
alias tfp="quik_TFPlan"
alias tfpIMPORT="quik_TFImportPlan"
alias tfIMPORT="tfpIMPORT"
alias tfa="quik_TFApply"
alias tfenvSET="quik_TF_EnvSet_or_SHOW"
alias tfenvset="tfenvSET"
alias tfdeployenv="tfenvSET"


# Before using? try to simply comment out (the resource or module invoke) and rerun plan/apply (whcih will destroy and keep state clean)
alias tfdap="echo ""; echo '**Before using tfdap, try to just comment the resources out in main.tf\n**..pausing..'; sleep 15; terraform plan -destroy -out=${tmpTFDestroy} ${TF_APPSTACK_CONFIG} && terraform apply \"${tmpTFDestroy}\" && rm -f ${tmpTFDestroy} 2>&1"

# ▮▮▮ Dealing wth TF state
alias tflist="echo; echo '   ** dont forget about \''terraform state show [tf_resource_id] \'' **'; echo; setCOL 3; terraform state list; echo"
alias tfshow="terraform state show"
alias tfremove="terraform state rm"
alias tfrm="tfremove"



