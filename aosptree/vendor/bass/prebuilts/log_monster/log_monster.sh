#!/system/bin/sh

# Check if at least one log type is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <log_type> [log_type...] [output_location]"
  exit 1
fi

# Assign output location to default if not provided
OUTPUT_LOCATION=${@: -1}
if [ "${OUTPUT_LOCATION:0:1}" != "/" ]; then
  OUTPUT_LOCATION="/sdcard/Documents"
fi

ZIP_NAME="logmonster"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_LOCATION

# Define custom log command
CUSTOM_LOG_COMMAND=""
while [ $# -gt 0 ]; do
  case $1 in
    -c|--custom)
      CUSTOM_LOG_COMMAND="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Collect logs
for LOG_TYPE in "${@:1:$#-1}"; do
  case $LOG_TYPE in
    dmesg)
      dmesg > ${OUTPUT_LOCATION}/dmesg.log
      ;;
    logcat)
      logcat -d > ${OUTPUT_LOCATION}/logcat.log
      ;;
    dumpsys)
      dumpsys > ${OUTPUT_LOCATION}/dumpsys.log
      ;;
    cpuinfo)
      cat /proc/cpuinfo > ${OUTPUT_LOCATION}/cpuinfo.log
      ;;
    all)
      dmesg > ${OUTPUT_LOCATION}/dmesg.log
      logcat -d > ${OUTPUT_LOCATION}/logcat.log
      dumpsys > ${OUTPUT_LOCATION}/dumpsys.log
      cat /proc/cpuinfo > ${OUTPUT_LOCATION}/cpuinfo.log
      ;;
    *)
      if [ -n "$CUSTOM_LOG_COMMAND" ]; then
        $CUSTOM_LOG_COMMAND > ${OUTPUT_LOCATION}/${LOG_TYPE}.log
      else
        echo "Unknown log type: $LOG_TYPE"
        exit 1
      fi
      ;;
  esac
done

# Create zip file
zip -r $OUTPUT_LOCATION/$ZIP_NAME.zip ${OUTPUT_LOCATION}/*.log
rm -rf ${OUTPUT_LOCATION%.*}/*.log