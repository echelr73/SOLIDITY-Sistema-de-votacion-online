//SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.9.0;
pragma experimental ABIEncoderV2;

contract votacion {

    // Direccion del propietario del contrato
    address owner = msg.sender;

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
        // Devuelve la lista de los candidatyos presentados
        return listaCandidatos;
    }

    function votar(string memory _nombre) public VotoUnico() VotoCorrecto(_nombre) {
        //Se calcula el hash del votante
        bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));

        //Se le suma un voto al candidato que viene por parametro
        Votos_Candidato[_nombre]++; 

        //Se suma al votante al arreglo de las personas que ya votaron
        listaVotantes.push(hash_votante);
    }

    function verVotos(string memory _nombre)public view VotoCorrecto(_nombre) returns(uint){
        return Votos_Candidato[_nombre];
    }

    modifier VotoUnico(){
        //Se calcula el hash del votante
        bytes32 hash_votante = keccak256(abi.encodePacked(msg.sender));

        //Se recorre el arreglo para verificar si la persona ya voto
        for(uint i=0; i<listaVotantes.length; i++){
            //Si el votante ya voto lanza un error
            require(listaVotantes[i] != hash_votante, "Solo se puede votar una vez");
        }
        _;
    }

    //Verifica que el candidato que entra como parametro sea un candidato que esta en la lista
    modifier VotoCorrecto(string memory _nombre){
        //Se calcula el hash del candidato
        bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombre));
        //Inicializacion de la variable 
        bool candidatoEncontrado = false;

        //Se recorre el arreglo para verificar si el nombre del candidato es correcto
        for(uint i=0; i<listaCandidatos.length; i++){
            //Se compara el hash de la lista de candidato con el hash de candidato ingresado
            if(keccak256(abi.encodePacked(listaCandidatos[i])) == hash_Candidato){
                candidatoEncontrado = true;
            }
        }
        //Si el parametro ingresado no se encuentra en la lista falla
        require(candidatoEncontrado, "No se encuentra al candidato");
        _;
    }

    //Funcion auxiliar que transforma un uint a un string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    //Ver los resultados de la votacion
    function verResultado() public view returns(string memory){
        //inicializacion de la variable
        string memory resultados = "";
        //vamos a recorrer la lista de candidatos
        for(uint i=0; i<listaCandidatos.length; i++){
            resultados = string(abi.encodePacked(resultados,listaCandidatos[i]," = ",uint2str(verVotos(listaCandidatos[i]))," | "));
            //listaCandidatos[i] + "=" + verVotos(listaCandidatos[i]) + " | ";
        }

        return resultados;
    }

    //Proporciona el nombre del candidato ganador
    function ganador() public view returns(string memory){
        //La variable ganador contiene el nombre del candidato ganador
        string memory ganadorVotos = listaCandidatos[0];
        //La variable flag sirve para la situacion de empate
        bool flag;

        //Recorremos el array de candidatos para determinar el candidato con mas votos
        for(uint i=1; i<listaCandidatos.length; i++){
            //Comparamos si nuestro ganador a sido superado por otro candidato
            if(Votos_Candidato[ganadorVotos] < Votos_Candidato[listaCandidatos[i]]){
                ganadorVotos = listaCandidatos[i];
                flag = false;
            }else{
                //Verificamos si hay empate entre los candidatos
                if(Votos_Candidato[ganadorVotos] == Votos_Candidato[listaCandidatos[i]]){
                    flag = true;
                }
            }
        }
        //Verificamos si hay un empate entre los candidatos
        if(flag){
            ganadorVotos = "Hay un empate entre los candidatos";
        }
        //devolvemos el ganador
        return ganadorVotos;
    }

}