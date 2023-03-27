#!/bin/bash

echo 'output,time' >> data.csv

ERC1155='/ERC1155.sol'
ERC721='/ERC721.sol'
ERC20='/ERC20.sol'
ERC3156='/ERC3156.sol'

for entry in  /home/Evolution_of_a_Fixed_Specification/**/**/* ; do
    
    case $entry in *"$ERC20" | *"$ERC721" | *"$ERC3156"| *"$ERC1155" )
        echo "$entry" >> data.csv
        start=$(date +%s%N)

        output_solc=$(solc-verify.py "$entry") 
        
        end=$(date +%s%N)

        echo  $output_solc,$(($(($end-$start))/1000000)) >> data.csv
        ;;
    esac

done;


# for entry in  /home/Evolution_Data_Refinement_and_Interface_Extension/**/**/* ; do
    
#     case $entry in *"$ERC20" | *"$ERC721" | *"$ERC3156"| *"$ERC1155" )
        
#         start=$(date +%s%N)

#         output_solc=$(solc-verify.py "$entry") 
        
#         end=$(date +%s%N)

#         echo  $output_solc,$(($(($end-$start))/1000000)) >> data.csv
#         ;;
#     esac

# done;
