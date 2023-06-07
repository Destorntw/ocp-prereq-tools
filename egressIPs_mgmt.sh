!/bin/bash
echo "Welcome to the hostsubnet $ netnamespace (Openshift SDN objects) patcher script"
wait 1s
echo "Would you like to: \
(1) - Add egress ip's to a project \
(2) - Add egress ip's to worker nodes"
read usr_choice
 if [ $usr_choice -eq 1 ]
 then

  echo "What is your node name prefix \
  exmaple: app-xx.ocp.example.com \
  the name prefix is "app-" \
  dont forget the "-" after node name prefix"
  read=prefix

  echo "What is your domain prefix and suffix \
  exmaple: app-xx.ocp.example.com \
  the full domain is ".ocp.example.com" \
  dont forget the dot before cluster name prefix ".ocp""
  read=domain

  echo -n "How many worker nodes do you have in your cluster \
  please note the script patches all worker nodes \
  exmaple: 67"
  read machine_count

  echo Your have enterd you have $machine_count worker nodes

  echo -n "How many IP addresses would you like to patch *SELECT NUMBER* - (1 IP) (2 IP's) (3 IP's) \
  Please note if you patch the same hostsubnet object twice than the patch OVER-RIDES the previous one!"
  read ipcount

  if [ $ipcount -eq 1 ]
  then

    echo "Enter your IP address"
    read ip1

    for ((i=1; i<=$machine_count; i++ ));
    do
      name="$prefix$i$domain"
      echo adding hostsubnet to node: $name
      oc patch hostsubnet $name --type=merge -p '{"egressIPs": ["'"$ip1"'"]}'
    done

  elif [ $ipcount -eq 2 ]
  then

    echo "Enter your IP address"
    read ip1
    echo "Enter your second IP address"
    read ip2

    for ((i=1; i<=$machine_count; i++ ));
    do
      name="$prefix$i$domain"
      echo adding hostsubnet to node: $name
      oc patch hostsubnet $name --type=merge -p '{"egressIPs": ["'"$ip1"'", "'"$ip2"'"]}'
    done

  elif [ $ipcount -eq 3 ]
  then

    echo "Enter your IP address"
    read ip1
    echo "Enter your second IP address"
    read ip2
    echo "Enter your third IP address"
    read ip3

    for ((i=1; i<=$machine_count; i++ ));
    do
      name="$prefix$i$domain"
      echo adding hostsubnet to node: $name
      oc patch hostsubnet $name --type=merge -p '{"egressIPs": ["'"$ip1"'", "'"$ip2"'", "'"$ip3"'"]}'
    done

  else
    echo "Wrong choice please re-run the script"
  fi


# Pathcer part 2 - patch netnamespace (adding egressIP)
 elif [ $usr_choice -eq 2 ]
 then

  echo -n "How many IP addresses would you like to add to a project  *SELECT NUMBER* - (1 IP) (2 IP's) (3 IP's) \
  Please note if you patch the same netnamespace object twice than the patch OVER-RIDES the previous one!"
  read ipcount_proj

  if [ $ipcount_proj -eq 1 ]
  then
    echo "Enter your project name"
    read proj_name
    echo "Enter your IP address"
    read ip1

      echo adding egress ip to project: $proj_name
      oc patch netnamespace $proj_name --type=merge -p '{"egressIPs": ["'"$ip1"'"]}'

  elif [ $ipcount_proj -eq 2 ]
  then
    echo "Enter your project name"
    read proj_name
    echo "Enter your first IP address"
    read ip1
    echo "Enter your second IP address"
    read ip2

    echo adding egress ip to project: $proj_name
    oc patch netnamespace $proj_name --type=merge -p '{"egressIPs": ["'"$ip1"'", "'"$ip2"'"]}'


  elif [ $ipcount_proj -eq 2 ]
  then

    echo "Enter your project name"
    read proj_name
    echo "Enter your first IP address"
    read ip1
    echo "Enter your second IP address"
    read ip2
    echo "Enter your third IP address"
    read ip3

    echo adding egress ip to project: $proj_name
    oc patch netnamespace $proj_name --type=merge -p '{"egressIPs": ["'"$ip1"'", "'"$ip2"'","'"$ip3"'"]}'

  else
          echo "Wrong choice please re-run the script"
  fi

 else
          echo "Wrong choice please re-run the script"
 fi

wait 1s
echo -n "A report will be generated indicating all of the updated hostsubnet's for each node\
file path is ./hostsub_report.txt"
oc get hostsubnet | awk '{print $1, $5, $6, $7}' >> ./hostsub_report.txt
echo "Report generation finished"

echo -n "A report will be generated indicating all of the updated egressIP's for each project\
file path is ./prject_egressIPs_report.txt"
oc get hostsubnet | awk '{print $1, $5, $6, $7}' >> ./prject_egressIPs_report.txt
echo "Report generation finished"
