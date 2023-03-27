# A refinement-based approach to safe smart contract deployment and evolution!

 

## Introduction

Smart contracts is a term used to describe computer code that is capable of self-execute business agreements between parties. Although they can hold millions of dollars’ worth of digital assets, there is still a great deal of difficulty in determining during the development process whether the smart contract will actually perform its functions as expected. To help to tackle these problems we propose TrustedDeployer. A systematic framework,  based on the design-by-contract methodology, targeting the Ethereum platform, that requires smart contracts to be formally verified before deployment. Ensuring that smart contracts are created and upgraded when they met their expected specification. We evaluate our framework on a number of real-world contracts to illustrate the benefits that our framework could have in real life. Even though formal verification is a very computationally-intensive process, our evaluation demonstrates that the sort of application we propose seems very tractable. In order to auxiliate the process developed on this project we used [solc-verify](https://github.com/SRI-CSL/solidity/blob/boogie/SOLC-VERIFY-README.md) (**v0.5.17**) , a source-level verification tool built on top of the Solidity compiler, and invariants, pre- and post-conditions are provided as annotations.


## Repositories


Although it is a consensus among  academic researchers that the use of formal analysis tools can help to increase the quality and reliability of software, it is still a cumbersome task to integrate them in the daily software-development process. So, to help to fill the gap between industry and academia, after proposing our new approach for safe creation and evolution of smart contracts, we designed an experiment, in order to show how simple and adaptable for various scenarios our framework can be. Our examples were based on ERC20 and ERC1155  standards. Even though, these standards were developed by the ethereum community as a way of organizing and disseminate the knowledge among the stakeholders, there are still problems related to the use of natural language, because they are inherently ambiguous, in addition there is a great difficulty in maintaining traceability between requirements and code. These standards were developed by the Ethereum community as a way of organizing and disseminating knowledge among the stakeholders and establishing well-defined specifications to describe the behavior of each of its methods. The specifications for each ERC are expressed under the terms of the standard RFC 2119, which defines several keywords that help describe the requirements, guide the understanding of it and extract the formal specifications.


**ERC20**

Proposed in 2015 by Vitalik Buterin, ERC20 it is one of the first stan-dards defined for the ethereum platform, and is also one of the most used, withmore than 360000 thousand active tokens on the network. Since it was created,there have been several critical flaws related to its development that have led tolarge financial losses. Several  initiatives  have  emerged  with  proposals  to  deal  with  these  problems,one of which, OpenZeppelin, provides solutions to build, automate and operate decentralized application. We selected 9 ERC20 open repositories to run the experiment.

[Ambrosus](https://github.com/ambrosus/Ambrosus.git), [DsToken](https://github.com/dapphub/ds-token.git), [Uniswap](https://github.com/Uniswap/uniswap-v2-core.git), [SkinCoin](https://github.com/Steamtradenet/smart-contract.git), [0xMonorepo](https://github.com/0xProject/0x-monorepo.git), [Minime](https://github.com/Giveth/minime.git), [Klenergy](https://github.com/klenergy/ethereum-contracts.git), [Digixdao](https://github.com/DigixGlobal/digixdao-contracts.git), [Openzeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts).


We also selected 5 ERC20 open repositories to to evaluate aspects related to changes in the data model and interface.


[Uniswap](https://github.com/Uniswap/uniswap-v2-core.git), [ConsenSys](https://github.com/ConsenSys/Tokens.git),
[SetProtocol](https://github.com/SetProtocol/set-protocol-contracts.git),[Digixdao](https://github.com/DigixGlobal/digixdao-contracts.git), [Bancor]()



**ERC1155**

The  ERC1155  standard  provides  an  interface  for  managing  anycombination of fungible and non-fungible tokens in a single contract efficiently. The standard was created in order to promote a better integration between the ERC20 and ERC721 standards, so with the ERC1155 token can perform the same functions as that the aforementioned tokens, improving the functionality of both and avoiding implementation errors. We selected 4 ERC20 open repositories to run the experiment.


[0xSequence](https://github.com/0xsequence/erc-1155), [Openzeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts), [Enjin](https://github.com/enjin/erc-1155), [Decentralized Stock Market](https://github.com/esdras-santos/decentralized_stock_market_ERC1155).



**ERC3156**

The ERC3156 standard is composed by ERC3156FlashBorrower and ERC3156FlashLender interfaces and together they provide a standardization for single-asset flash loans. We selected 5 ERC3156 open repositories to run the experiment.


[ArgoBytes](https://github.com/SatoshiAndKin/argobytes-contracts.git), [Dss Flash](https://github.com/hexonaut/dss-flash.git), [Erc3156](https://github.com/fifikobayashi/ERC3156.git), [Wrappes](https://github.com/albertocuestacanada/ERC3156-Wrappers.git), [Weth10](https://github.com/WETH10/WETH10.git).


**ERC721**

The ERC-721 standard defines a minimum interface a smart contract must implement to allow unique tokens to be managed, owned, and traded. The more common term used to refer to these assets is non-fungible tokens. We selected 1 ERC721 open repository to run the experiment. We also selected 1 ERC721 open repositories to to evaluate aspects related to changes in the data model and interface.

[Openzeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)

## Verify contracts

In order to build the docker container and verify the smart contracts in this repository. Please follow the instructions presented in [solc-verify](https://github.com/SRI-CSL/solidity/blob/boogie/docker/README.md) github page.

## Running The Verification Script


This Docker allows us to quickly run the Verification Tool.
To build the tool in a docker container you should clone the project and  run the the following commands:

```
docker-compose build
docker-compose up 
```


## Running The Verification Tool


This Docker allows us to quickly run the Verification Tool.
To build the tool in a docker container you should clone the project and in the tool directory run the the following command:

```
docker-compose up --build tool
```

The tool can be accessed through the link: http://localhost:3000/#/

To access the features of the tool it is necessary to have a metamask wallet. All instructions for creating, importing, and getting backgrounds are on the tool's documentation page.





##  Citing

This research is a part of effort to extend the work that we present in the 20th International Conference on
Software Engineering and Formal Methods [[1]](#1); If you want to refer to our previous work, please use the following BibTeX entry for citation.

```
@InProceedings{10.1007/978-3-031-17108-6_14,
    author="Antonino, Pedro and Ferreira, Juliandson and Sampaio, Augusto and Roscoe, A. W.",
    editor="Schlingloff, Bernd-Holger and Chai, Ming",
    title="Specification is Law: Safe Creation and Upgrade of Ethereum Smart Contracts",
    booktitle="Software Engineering and Formal Methods",
    year="2022",
    publisher="Springer International Publishing",
    address="Cham",
    pages="227--243",
    abstract="Smart contracts are the building blocks of the 'code is law' paradigm: the smart contract's code indisputably describes how its assets are to be managed - once it is created, its code is typically immutable. Faulty smart contracts present the most significant evidence against the practicality of this paradigm; they are well-documented and resulted in assets worth vast sums of money being compromised. To address this issue, the Ethereum community proposed (i) tools and processes to audit/analyse smart contracts, and (ii) design patterns implementing a mechanism to make contract code mutable. Individually, (i) and (ii) only partially address the challenges raised by the 'code is law' paradigm. In this paper, we combine elements from (i) and (ii) to create a systematic framework that moves away from 'code is law' and gives rise to a new 'specification is law' paradigm. It allows contracts to be created and upgraded but only if they meet a corresponding formal specification. The framework is centered around a trusted deployer: an off-chain service that formally verifies and enforces this notion of conformance. We have prototyped this framework, and investigated its applicability to contracts implementing three widely used Ethereum standards: the ERC20 Token Standard, ERC3156 Flash Loans and ERC1155 Multi Token Standard, with promising results.",
    isbn="978-3-031-17108-6"
}
```

##  References

<a id="1">[1] Antonino, P., Ferreira, J., Sampaio, A., Roscoe, A.W. (2022). Specification is Law: Safe Creation and Upgrade of Ethereum Smart Contracts. In: Schlingloff, BH., Chai, M. (eds) Software Engineering and Formal Methods. SEFM 2022. Lecture Notes in Computer Science, vol 13550. Springer, Cham. https://doi.org/10.1007/978-3-031-17108-6_14
