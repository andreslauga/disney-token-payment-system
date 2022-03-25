# Disney token payment system

Project written in Solidity that I did during a Blockchain course. This was helpful for me to acquire the main concepts of Smart Contracts. In this case, the contract controls a payment system for a disney park.

## Disclaimer

**I'm not the author of this code**. I just followed the tutorial to learn the concepts and practice Solidity.
This project is part of the awesome course [Curso Completo de Blockchain de cero a experto](https://www.udemy.com/course/curso-completo-de-blockchain-de-la-a-a-la-z/) by **Joan Amengual** and **Juan Gabriel Gomila Salas**. It's in spanish :)

You may notice some strange messages on the code that get printed in the logs as you interact with the contract. I do this because of three reasons: 1, practice my english skills, 2, keeps me focus and motivated while I write the code, and 3, **it's a lot more fun!**

## Test the Smart Contract

1. There are three .sol files in this project. Download them.
2. Open [Remix IDE](https://remix.ethereum.org/).
3. Create a new folder and upload the .sol files inside it.
4. Compile the Disney.sol file. 
5. Select Disney contract and deploy it in "Deploy & Run transactions" section.
6. Play arround with the smart contract methods using some test accounts from the list in "Deployed Contracts" section. Note that the selected account at the moment of deploy will be the owner of the contract, or you can call it "Disney" in this case.
7. You can now Create attractions and dishes, remove them, generate new tokens, etc.
8. To use this contract as a customer point of view, you have to select another account from the list.
9. In order to take an attraction or eat a dish, you have to buy tokens in first place. In the "value" section, you have to put the amount of ether you will spend and select Ether from the dropdown menu. Now you can buy tokens using buyTokens function.
10. Play arround with the other methods! Try to use Owner-only functions (like "NewAttraction()") and see what happens. Or maybe you want to take atractions, see your account balance or get your ethers back giving your remaining tokens. It's on you! :)
