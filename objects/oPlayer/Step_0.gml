#region CONTROLES
direita = keyboard_check(ord("D"));
esquerda = keyboard_check(ord("A"));
cima = keyboard_check_pressed(vk_space);
#endregion

#region VELOCIDADE HORIZONTAL + SPRITE
var move = direita - esquerda;
hveloc = move * veloc;


// Mudando sprite
if (vveloc < 0 && hveloc > 0) {
    // Movendo para cima e para a direita junto
    sprite_index = sPlayerPulaLadoD;
	mirar = 0;
	
} else if (vveloc < 0 && hveloc < 0) {
    // Movendo para cima e para a esquerda junto
    sprite_index = sPlayerPulaLadoE;
	mirar = 1;
	
} else if (hveloc > 0) {
    // Movendo para a direita
    sprite_index = sPlayerCorreD;
	mirar = 0;
	
} else if (hveloc < 0) {
    // Movendo para a esquerda
    sprite_index = sPlayerCorreE;
	mirar = 1;
	
} else if (vveloc < 0) {
    // Apenas pulando
    sprite_index = sPlayerPula;
} else {
    // Parado
    sprite_index = sPlayer;
}

#endregion

#region COLISÃO H
if (!place_meeting(x, y, oEscada)) {
    if (place_meeting(x + hveloc, y, oChao)
    or place_meeting(x + hveloc, y, oPlataforma)
    or place_meeting(x + hveloc, y, oChaoMenor)
    or place_meeting(x + hveloc, y, oMadeiraChao)
    or place_meeting(x + hveloc, y, oMadeiraPlataforma)
    or place_meeting(x + hveloc, y, oMadeiraQb)) {
        while (!place_meeting(x + sign(hveloc), y, oChao)
        and !place_meeting(x + sign(hveloc), y, oPlataforma)
        and !place_meeting(x + sign(hveloc), y, oChaoMenor)
        and !place_meeting(x + sign(hveloc), y, oMadeiraChao)
        and !place_meeting(x + sign(hveloc), y, oMadeiraPlataforma)
        and !place_meeting(x + sign(hveloc), y, oMadeiraQb)) {
            x += sign(hveloc);
        }
        hveloc = 0;
    }
}

x += hveloc;
#endregion

#region COLISÃO V

if (place_meeting(x, y, oEscada)) {

    if (keyboard_check(ord("W"))) {
        sprite_index = sPTeste;
        vveloc = -2.5;
        gravidade = 0;
    } else if (keyboard_check(ord("S"))) {
        sprite_index = sPTeste;
        vveloc = 2.5;
        gravidade = 0;
    } else if (keyboard_check_pressed(vk_space) && !place_meeting(x, y - 1, oEscada)) {
        vveloc = -4.8; 
        gravidade = 0.19;
    } else {
        vveloc = 0;
    }
} else {
    gravidade = 0.19;

    if (place_meeting(x, y + vveloc, oChao)
    or place_meeting(x, y + vveloc, oPlataforma)
    or place_meeting(x, y + vveloc, oChaoMenor)
    or place_meeting(x, y + vveloc, oMadeiraChao)
    or place_meeting(x, y + vveloc, oMadeiraPlataforma)
    or place_meeting(x, y + vveloc, oMadeiraQb)) {
        while (!place_meeting(x, y + sign(vveloc), oChao)
        and !place_meeting(x, y + sign(vveloc), oPlataforma)
        and !place_meeting(x, y + sign(vveloc), oChaoMenor)
        and !place_meeting(x, y + sign(vveloc), oMadeiraChao)
        and !place_meeting(x, y + sign(vveloc), oMadeiraPlataforma)
        and !place_meeting(x, y + sign(vveloc), oMadeiraQb)) {
            y += sign(vveloc);
        }
        vveloc = 0;
    }
}

y += vveloc;
#endregion



#region Gravidade e Pulo

if (!place_meeting(x, y + 1, oChao)
and !place_meeting(x, y + 1, oPlataforma)
and !place_meeting(x, y + 1, oChaoMenor)
and !place_meeting(x, y + 1, oMadeiraChao) 
and !place_meeting(x, y + 1, oMadeiraPlataforma)
and !place_meeting(x, y + 1, oMadeiraQb)) {
    vveloc += gravidade; // Aplica gravidade quando não está no chão
} else {
    if (cima) {
        vveloc = -4.8;  // Velocidade vertical para o pulo normal
    } else {
        vveloc = 0;  // Zera a velocidade vertical ao tocar o chão
    }
}


 #endregion

#region TIRO
	var tiro = keyboard_check_pressed(ord("Q")) // TECLA Q = TIRO
	if (tiro){ //SE Q FOR PRESSIONADO...
		var t = instance_create_layer(x, y, layer, oTiro); //ADICIONA UMA CAMADA PARA O TIRO
		t.speed = 7; //VELOCIDADE DO TIRO
		t.dano = irandom_range(1,3);  //UM DANO ALEATORIO ENTRE 1 E 3
		t.direction=180*mirar; //SABER QUANDO O TIRO TEM Q VIRAR
	}
#endregion

#region CAIXA
if (keyboard_check_pressed(vk_control)) {
	
	//distancia pra quebrar a caixa rs
    var max_distance = 50;
    var caixa = instance_nearest(x, y, oCaixa);
    if (caixa != noone && point_distance(x, y, caixa.x, caixa.y) <= max_distance) {
        //caixa explosão
        caixa.sprite_index = sCaixaExplode;
        caixa.image_index = 0;
        // reproduz só uma vez
        caixa.image_speed = 1;
		
        caixa.exploding = true;
    }
}
#endregion

#region Reinicia room
if (keyboard_check(ord("R"))) {
    room_restart();
}
#endregion


//escada falhada





#region POWERUP
//dps cria outro if pra verificar se a "compra" do powerup foi realizada
//pra ativar.

if(keyboard_check(ord("1"))){
        tempo_superpulo++;
		pulo = true;
}
#region SUPERPULO
if (tempo_superpulo >= tempo_maximo_superpulo && pulo == true) { 
    vveloc = -4.3;  // Execute normal jump
    pulo = false;   // Reset jump
} else {

    if (cima) {

		vveloc = -6.3;
        pulo = true;
    }
}

// Super jump logic
if (!pulo && tempo_superpulo <= tempo_maximo_superpulo) {
    if (cima) {  // Assuming 'cima' is the input for upwards movement
        vveloc = -6.3;  // Set the vertical velocity for super jump
          super_pulo_ativo = true;  // Activate super jump state
    }
}

show_debug_message(tempo_superpulo)

//2
var tiro_duplo = keyboard_check_pressed(ord("2"));

if (tiro_duplo && !tiro_criadod) { // SE 2 FOR PRESSIONADO E O TIRO NÃO FOI CRIADO
    var t_duplo = instance_create_layer(x, y, layer, oTiroDuplo); // CRIA O TIRO
    t_duplo.speed = 7; // VELOCIDADE DO TIRO
    t_duplo.dano = irandom_range(1, 3); // DANO ALEATÓRIO ENTRE 1 E 3
    t_duplo.direction = 180 * mirar; // DIREÇÃO DO TIRO
    //tiro_criadod = true; // Marca que o tiro foi criado (se tirar de comment, só atira 1 vez
}

tempo_gelado += 1;

if (tempo_gelado > tempo_maximo_gelado) {
    global.veloc = 0.8;
}


//3
#region TIRO GELO

var tiro_gelo = keyboard_check_pressed(ord("3"));

if (tiro_gelo && !tiro_criadog) { // SE 3 FOR PRESSIONADO E O TIRO NÃO FOI CRIADO
    var t_gelo = instance_create_layer(x, y, layer, oTiroGelo); // CRIA O TIRO
    t_gelo.speed = 7; // VELOCIDADE DO TIRO
    t_gelo.dano = irandom_range(1, 3); // DANO ALEATÓRIO ENTRE 1 E 3
    t_gelo.direction = 180 * mirar; // DIREÇÃO DO TIRO
    tiro_criadog = true; // Marca que o tiro foi criado
}

tempo_gelado += 1;

if (tempo_gelado > tempo_maximo_gelado) {
    global.veloc = 0.8;
}

#endregion

//4 no inimigo

//5
#region ENFURECIDO

tempo_enfurecido += 1;

if (tempo_enfurecido <= tempo_maximo_enfurecido) {
    if (keyboard_check_pressed(ord("5"))) {
        veloc = 5.3;
        tempo_enfurecido = 0; 
    }
} else {
    veloc = 3;
}

#endregion


//6 DANDO ERRO PQ APAGUEI O COD DE SEGUIR
#region INVISIVEL

tempo_invisivel += 1;
if (tempo_invisivel <= tempo_maximo_invisivel) {
    if (keyboard_check_pressed(ord("6")) && !invisivel && global.seguindo) {
        global.seguindo = false;
    }
} else {
    global.seguindo = true;
}

#endregion

//se minha sala for igual a de index 1 (a segunda sala), nunhum poder vai funcionar) 
//acho q n vai precisar mas deixei ai
if (room == 1) {
    tiro_criado = false;
    super_pulo = false;
    tecla_pulo = false;
    pulo_forca = -7.3;
    veloc = 3;
}

#endregion

#endregion