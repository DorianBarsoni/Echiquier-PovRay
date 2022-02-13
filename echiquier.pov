#include "shapes.inc"
#include "colors.inc"
#include "textures.inc"
#include "woods.inc"
#include "glass.inc"
#include "metals.inc"
#include "functions.inc" 
#include "stones1.inc"
#include "skies.inc"
 

//<-5, 4, 5> <4, 4, 0> vue de coté
//<4, -3.5, 9> <4, 4, 0> vue jeu
camera {
location <4, -3.5, 9>
 look_at <4, 4, 0>
 sky   <0,0,1> // pour avoir le Z en haut
 right <-image_width/image_height,0,0> // pour un repere direct
}

light_source { <0, 0, 8> color White }
light_source { <4, 4, 4> color White }

background {White}

global_settings{
  max_trace_level 60//32*3
  ambient_light 1.00
  assumed_gamma 2.0
}









//CRÉATION ECHIQUIER
//Création du damier
    #for (col, 0, 7)
        #for (lig, 0, 7)
            #if ( mod(lig+col, 2) != 1)
                box {<lig, col, 0> <lig+1, col+1, 0.3> texture {T_Wood26} }
                #else
                box {<lig, col, 0> <lig+1, col+1, 0.3> texture {T_Wood23} }
            #end
        #end
    #end 
//Création du plateau
    box{ <-1, -1, -0.1> <9, 9, 0> texture {T_Wood26} }


//TEXTE ECHIQUIER
#declare Tableau_Lettres = array[8] {"A", "B", "C", "D", "E", "F", "G", "H"};
    //chiffres endroit
    #for (lig, 0, 7)
        text { ttf "timrom.ttf" str(lig + 1, 0, 0) 0.05, 0 scale 1 translate <-0.5, lig+0.1, 0> texture{T_Wood23} }
    #end
    //lettres endroit
    #for (col, 0, 7)
        text { ttf "timrom.ttf" Tableau_Lettres[col] 0.05, 0 scale 1 translate <col+0.1, -0.8, 0> texture{T_Wood23} }
    #end
    //Chiffres envers
    #for (lig, 0, 7)
        text { ttf "timrom.ttf" str(lig + 1, 0, 0) 0.05, 0 scale 1 rotate <0, 0, 180> translate <8.5, lig+0.9, 0> texture{T_Wood23} }
    #end
    //Lettres envers
    #for (col, 0, 7)
        text { ttf "timrom.ttf" Tableau_Lettres[col] 0.05, 0 scale 1 rotate <0, 0, 180> translate <col+0.9, 8.8, 0> texture{T_Wood23} }
    #end
          
          
          
//CRÉATION DES PIÈCES
    //Création des Pions
    #macro Pion(co_x, co_y, co_z, textur)
        union {
                cylinder { <0, 0, 1>, <0, 0, 1.1>, 0.3 texture{textur} } //Base
                lathe { bezier_spline 4 <0.3, 1.1> <0.3, 1.15> <0.225, 1.2> <0.15, 1.2> rotate <90, 0, 0> texture {textur} } //Base
                lathe { bezier_spline 4 <0.15, 1.2> <0.05, 1.2> <0.05, 1.5> <0.12, 1.5> rotate <90, 0, 0> texture {textur} } //Corps
                sphere {<0, 0, 1.65> 0.17 texture{textur} } //Tête
                lathe { bezier_spline 4 <0.12, 1.5> <0.16, 1.5> <0.17, 1.62> <0.17, 1.65> rotate <90, 0, 0> texture {textur} } //Liaison corps tête
                translate <co_x, co_y, co_z>
                }
    #end
    //Placement des Pions
    #for (i, 0, 7)
        #switch (i)      
            #case(4)
                #break
            #case(5)
                Pion(0.5+i, 1.5, -0.7, T_Wood23) //Pions blancs
                #break
            #else
                Pion(0.5+i, 1.5, -0.7, T_Wood23) //Pions blancs
                Pion(0.5+i, 6.5, -0.7, T_Wood26) //Pions noirs
         #end     
    #end
    
      
      
    //Création des Tours
    #macro Tour(co_x, co_y, co_z, textur)
        union {
                cylinder { <0, 0, 1>, <0, 0, 1.1>, 0.3 texture{textur} } //Base
                lathe { bezier_spline 4 <0.3, 1.1> <0.3, 1.2> <0.25, 1.3> <0.2, 1.3> rotate <90, 0, 0> texture {textur} } //Base
                lathe { bezier_spline 4 <0.2, 1.3> <0.1, 1.3> <0.10, 1.7> <0.25, 1.7> rotate <90, 0, 0> texture {textur} } //Tige
                difference { //Tête
                    difference {
                        difference { 
                            cylinder { <0, 0, 1.7>, <0, 0, 2>, 0.25 texture{textur} }
                            cylinder { <0, 0, 1.72>, <0, 0, 2.1>, 0.20}
                            cutaway_textures
                                }
                        box { <-0.35, -0.05, 1.9> <0.35, 0.05, 2.1>}
                        cutaway_textures
                            }
                    box { <-0.05, -0.35, 1.9> <0.05, 0.35, 2.1>}
                    cutaway_textures
                   }
                translate <co_x, co_y, co_z>
                }
    #end
    //Placement des Tours
    #for (i, 0, 1)
        Tour(0.5+i*7, 0.5, -0.7, T_Wood23)
        Tour(0.5+i*7, 7.5, -0.7, T_Wood26)
    #end
     
        
        
    //Création des cavaliers
    #macro Cavalier(co_x, co_y, co_z, textur, rota)
        union {
                cylinder { <0, 0, 1>, <0, 0, 1.1>, 0.3 texture{textur} } //Base
                lathe { bezier_spline 4 <0.3, 1.1> <0.3, 1.2> <0, 1.3> <0, 1.3> rotate <90, 0, 0> texture{textur} } //Base
                intersection {
                    cone { <0, 0, 1.>, 0.15 <0, 0, 1.9>, 0.3 texture{textur} } //Corps
                    box { <-0.1, -1, 0> <0.1, 1, 2>}
                    cutaway_textures
                    }
                difference {
                    difference {
                        difference {
                            difference {
                                difference {
                                    intersection {
                                        cone { <0, 0.4, 1.9>, 0.1 <0, -0.3, 1.9> 0.3 texture{textur} } //Tête
                                        box { <-0.17, -1, 0> <0.17, 1, 3> }
                                        cutaway_textures
                                        }
                                    sphere { <-0.15, -0.15, 2> 0.05 } //Yeux
                                    cutaway_textures
                                    }
                                sphere { <0.15, -0.15, 2> 0.05 } //Yeux
                                cutaway_textures
                                }
                            sphere { <0, 0.41, 2> 0.05} //Museau
                            cutaway_textures
                            }
                        sphere { <0.04, 0.4, 1.9> 0.03 } //Museau
                        cutaway_textures
                        }
                    sphere { <-0.04, 0.4, 1.9> 0.03 } //Museau
                    cutaway_textures
                    }
                    difference {
                        cone {<0, 0, 2.1>, 0.05 <0, 0, 2.3>, 0 texture{textur} } //Oreilles
                        plane { <0, -1, 0> 0}
                        cutaway_textures
                        translate <-0.1, -0.2, 0>
                        }
                    difference {
                        cone {<0, 0, 2.1>, 0.05 <0, 0, 2.3>, 0 texture{textur} } //Oreilles
                        plane { <0, -1, 0> 0}
                        cutaway_textures
                        translate <0.1, -0.2, 0>
                        }
               rotate <0, 0, rota>
               translate <co_x, co_y, co_z>
               }
    #end
    //Placement des Cavaliers
    #for (i, 0, 1)
        Cavalier(1.5+i*5, 0.5, -0.7, T_Wood23, 0)
    #end
    
     
     
    //Création des Fous
    #macro Fou(co_x, co_y, co_z, textur, rota)
        union {
                difference {
                    difference {
                        blob {
                            threshold 1.15
                            sphere { <0, 0, 1.1> 0.5 1.5 } //Base
                            cylinder { <0, 0, 1.1>, <0, 0, 2>, 0.3 1.5 } //Corps
                            sphere { <0, 0, 2.2> 0.5 1.5 } //Tête
                            sphere { <0, 0, 2.4> 0.05, 1.5} //Haut de tête
                            texture{textur}
                            sturm on
                            hierarchy off
                            }
                        plane { <0, 0, 1> 1.1}
                        cutaway_textures
                        }
                    box { <-0.3, 0.1, 2.15> <0.3, 0.15, 2.4> }
                    cutaway_textures
                    }
                rotate <0, 0, rota>
                translate <co_x, co_y, co_z>
                }
    #end
    //Placement des Fous
    #for (i, 0, 1)
        Fou(2.5+i*3, 7.5, -0.8, T_Wood26, 180)
    #end
    Fou(2.5, 0.5, -0.8, T_Wood23, 0)
    
    
    
    //Création de la Dame
    #macro Dame(co_x, co_y, co_z, textur)
        union {
            cylinder { <0, 0, 1>, <0, 0, 1.1>, 0.3 texture{textur} } //Base
            lathe { bezier_spline 4 <0.3, 1.1> <0.3, 1.2> <0.25, 1.3> <0.2, 1.3> rotate <90, 0, 0> texture {textur} } //Base
            lathe { bezier_spline 4 <0.2, 1.3> <0.10, 1.3> <0.10,2.3> <0.2, 2.3> rotate <90, 0, 0> texture {textur} } //Corps
            cylinder { <0, 0, 2.12> <0, 0, 2.15> 0.2 texture{textur} } //Finition corps
            cone {<0, 0, 2.3>, 0.2 <0, 0, 2.6>, 0.25 texture{textur} } //Tête
            lathe { bezier_spline 4 <0.25, 2.6> <0.25, 2.65> <0.15, 2.7> <0,2.7> rotate <90, 0, 0> texture {textur} }
            torus {0.25 0.05 texture{textur} rotate <90, 0, 0> translate <0, 0, 2.6> } //Tête
            sphere { <0, 0, 2.7> 0.05 texture{textur} } //Tête
            translate <co_x, co_y, co_z>   
            }
    #end
    //Placement des Dames
    Dame(3.5, 7.5, -0.7, T_Wood26)
    
    
    
    //Création du Roi
    #macro Roi(co_x, co_y, co_z, textur)
        union {
            cylinder { <0, 0, 1>, <0, 0, 1.1>, 0.3 texture{textur} } //Base
            lathe { bezier_spline 4 <0.3, 1.1> <0.3, 1.2> <0.25, 1.3> <0.2, 1.3> rotate <90, 0, 0> texture {textur} } //Base
            lathe { bezier_spline 4 <0.2, 1.3> <0.10, 1.3> <0.10,2.4> <0.2, 2.4> rotate <90, 0, 0> texture {textur} } //Corps
            cylinder { <0, 0, 2.22> <0, 0, 2.25> 0.2 texture{textur} } //Finition corps
            cylinder { <0, 0, 2.15> <0, 0, 2.18> 0.2 texture{textur} } //Finition corps
            cone { <0, 0, 2.4>, 0.2 <0, 0, 2.7>, 0.25 texture{textur} } //Tête
            lathe { bezier_spline 4 <0.25, 2.7> <0.25, 2.72> <0.15, 2.75> <0, 2.75> rotate <90, 0, 0> texture {textur} } //Tête
            torus { 0.25 0.03 texture{textur} rotate <90, 0, 0> translate <0, 0, 2.7> } //Tête
            box { <-0.03, -0.01, 2.72> <0.03, 0.01, 2.95> texture{textur} }
            box { <-0.06, -0.009, 2.86> <0.06, 0.009, 2.92> texture{textur} }
            translate <co_x, co_y, co_z>
            }
    #end
    //Placement des Rois
    Roi(4.5, 0.5, -0.7, T_Wood23)
    Roi(4.5, 7.5, -0.7, T_Wood26)
    
    
 
//ANIMATION
    
    //Premier coup
    #if (clock < 1/7)
        //Mouvement rectiligne
        Pion(4.5, 1.5+2*7*clock, -0.7, T_Wood23)
        Pion(4.5, 6.5, -0.7, T_Wood26)
        Fou(5.5, 0.5, -0.8, T_Wood23, 0)
        Cavalier(1.5, 7.5, -0.7, T_Wood26, 180)
        Dame(3.5, 0.5, -0.7, T_Wood23)
        Cavalier(6.5, 7.5, -0.7, T_Wood26, 180)
        
        Pion(5.5, 6.5, -0.7, T_Wood26)
    #end
    //Deuxième coup
    #if (1/7 <=clock & clock < 2/7)
        //Mouvement rectiligne
        Pion(4.5, 3.5, -0.7, T_Wood23)
        Pion(4.5, 6.5-2*7*(clock-1/7), -0.7, T_Wood26)
        Fou(5.5, 0.5, -0.8, T_Wood23, 0)
        Cavalier(1.5, 7.5, -0.7, T_Wood26, 180)
        Dame(3.5, 0.5, -0.7, T_Wood23)
        Cavalier(6.5, 7.5, -0.7, T_Wood26, 180)
        Pion(5.5, 6.5, -0.7, T_Wood26)
    #end
    
    //Troisième coup
    #if (2/7 <= clock & clock < 3/7)
        //Mouvement rectiligne
        Pion(4.5, 3.5, -0.7, T_Wood23)
        Pion(4.5, 4.5, -0.7, T_Wood26)
        Fou(5.5-3*7*(clock-2/7), 0.5+3*7*(clock-2/7), -0.8, T_Wood23, 0)
        Cavalier(1.5, 7.5, -0.7, T_Wood26, 180)
        Dame(3.5, 0.5, -0.7, T_Wood23)
        Cavalier(6.5, 7.5, -0.7, T_Wood26, 180)
        Pion(5.5, 6.5, -0.7, T_Wood26)    
    #end
    
    //Quatrième coup
    #if (3/7 <= clock & clock < 4/7)
        //Mouvement courbe
        //Variable et calcul de la courbe de Bézier
        #declare tmp = 7*(clock-(3/7));
        #declare P0 = <7.5, -0.7>;
        #declare P1 = <9.5, 1.3>;
        #declare P2 = <3.5, 1.3>;
        #declare P3 = <5.5, -0.7>;
        #declare pt_courbe_bezier = pow((1-tmp),3)*P0+3*pow((1-tmp),2)*tmp*P1+3*(1-tmp)*pow(tmp,2)*P2+pow(tmp,3)*P3;
        
        //Création des pièces
        Pion(4.5, 3.5, -0.7, T_Wood23)
        Pion(4.5, 4.5, -0.7, T_Wood26)
        Fou(2.5, 3.5, -0.8, T_Wood23, 0)
        Cavalier(1.5+1*7*(clock-3/7), pt_courbe_bezier.x, pt_courbe_bezier.y, T_Wood26, 180)
        Dame(3.5, 0.5, -0.7, T_Wood23)
        Cavalier(6.5, 7.5, -0.7, T_Wood26, 180)
        Pion(5.5, 6.5, -0.7, T_Wood26)
    #end
      
    //Cinquième coup
    #if (4/7 <= clock & clock < 5/7)
        //Mouvement rectiligne
        Pion(4.5, 3.5, -0.7, T_Wood23)
        Pion(4.5, 4.5, -0.7, T_Wood26)
        Fou(2.5, 3.5, -0.8, T_Wood23, 0)
        Cavalier(2.5, 5.5, -0.7, T_Wood26, 180)
        Dame(3.5+4*7*(clock-4/7), 0.5+4*7*(clock-4/7), -0.7, T_Wood23)
        Cavalier(6.5, 7.5, -0.7, T_Wood26, 180)
        Pion(5.5, 6.5, -0.7, T_Wood26)
    #end 
    
    //Sixième coup
    #if (5/7 <= clock & clock <= 6/7)
        //Mouvement courbe
        //Variable et calcul de la courbe de Bézier
        #declare tmp = 7*(clock-(5/7));
        #declare P0 = <7.5, -0.7>;
        #declare P1 = <9.5, 1.3>;
        #declare P2 = <3.5, 1.3>;
        #declare P3 = <5.5, -0.7>;
        #declare pt_courbe_bezier = pow((1-tmp),3)*P0+3*pow((1-tmp),2)*tmp*P1+3*(1-tmp)*pow(tmp,2)*P2+pow(tmp,3)*P3;
        
        Pion(4.5, 3.5, -0.7, T_Wood23)
        Pion(4.5, 4.5, -0.7, T_Wood26)
        Fou(2.5, 3.5, -0.8, T_Wood23, 0)
        Cavalier(2.5, 5.5, -0.7, T_Wood26, 180)
        Dame(7.5, 4.5, -0.7, T_Wood23)
        Cavalier(6.5-1*7*(clock-5/7), pt_courbe_bezier.x, pt_courbe_bezier.y, T_Wood26, 180)
        Pion(5.5, 6.5, -0.7, T_Wood26)
    #end
    
    //Septième coup
    #if (6/7 <= clock & clock < 1)
        //Mouvement rectiligne
        Pion(4.5, 3.5, -0.7, T_Wood23)
        Pion(4.5, 4.5, -0.7, T_Wood26)
        Fou(2.5, 3.5, -0.8, T_Wood23, 0)
        Cavalier(2.5, 5.5, -0.7, T_Wood26, 180)
        Dame(7.5-2*(35/4)*(clock-6/7), 4.5+2*(35/4)*(clock-6/7), -0.7, T_Wood23)
        Cavalier(5.5, 5.5, -0.7, T_Wood26, 180)
        
        //Mouvement rectiligne et ascendant/descendant
        #if (6/7 <= clock & clock < (6/7)+(1/21))
            Pion(5.5, 6.5, -0.7+3.7*7*(clock-(6/7)), T_Wood26)
        #end
        #if ((6/7)+(1/21) <= clock & clock < (6/7)+(2/21))
            Pion(5.5+3.3*7*(clock-((6/7)+(1/21))), 6.5, 3, T_Wood26)   
        #end
        #if ((6/7)+(2/21) <= clock)
            Pion(8.8, 6.5, 3-4*(105/2)*(clock-((6/7)+(2/21))), T_Wood26)  
        #end
    #end   

     