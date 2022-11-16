//SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.9.0;
pragma experimental ABIEncoderV2;

contract votacion {

    // Direccion del propietario del contrato
    address public owner = msg.sender;

    // Relacion entre el nombre del candidato y el hash de sus datos personales
    mapping (string => bytes32) ID_Candidato;

    // Relacion entre el candidato y el numero de votos
    mapping (string => uint) Votos_Candidato;

    // Lista que almacena los candidatos
    string [] listaCandidatos;

    // Lista de hash que almacena los votantes
    bytes32 [] listaVotantes;

    // Funcion para prensentar candidatos
    function representar(string memory _nombre, uint _edad, string memory _id) public {
        // Calcular el hash de los datos
        bytes32 hashCandidato = keccak256(abi.encodePacked(_nombre, _edad, _id));

        //Almacenar el hash de los datos del candidato ligados a su nombre
        ID_Candidato[_nombre] = hashCandidato;

        //Almacenamos el nombre del candidato
        listaCandidatos.push(_nombre);
    }

    // Funcion para mostrar los candidatos
    function varCandidatos() public view returns(string[] memory){
        return listaCandidatos;
    }


    //modifier VotoUnico(){
    //    for(uint i=0; i<listaVotantes.length; i++){
    //        require(listaVotantes[i] != msg.sender, "Solo se puede votar una vez");
    //    }
    //    _;
    //}
}