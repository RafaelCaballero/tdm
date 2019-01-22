
/*
db.capturasTotal.drop()
db.evolucion.drop()
db.capturasImportantes.drop()
db.masPuntos.drop()
db.bichosPorClase.drop()
db.puntosMedio.drop()
db.capturasTotalPorNombre.drop()
db.capturadores.drop()
db.evolucion.drop()

*/

/*1*/
db.capturasTotal.drop()
db.createView("capturasTotal","capturas", 
             [{'$group': 
			     {_id:{user:'$user',bicho:'$bicho'}, 
			      total:{$sum:"$puntos"}} }, {'$sort':{_id:1}} ])
db.capturasTotal.find()

/*
{ "_id" : { "user" : 1, "bicho" : "cassandro" }, "total" : 650 }
{ "_id" : { "user" : 1, "bicho" : "chorizard" }, "total" : 125 }
{ "_id" : { "user" : 1, "bicho" : "snoreless" }, "total" : 950 }
{ "_id" : { "user" : 2, "bicho" : "cassandro" }, "total" : 550 }
{ "_id" : { "user" : 2, "bicho" : "plastoise" }, "total" : 1150 }
{ "_id" : { "user" : 2, "bicho" : "snoreless" }, "total" : 1150 }
{ "_id" : { "user" : 3, "bicho" : "belcebuh" }, "total" : 50 }
{ "_id" : { "user" : 3, "bicho" : "cassandro" }, "total" : 750 }
{ "_id" : { "user" : 3, "bicho" : "chorizard" }, "total" : 430 }
{ "_id" : { "user" : 3, "bicho" : "snoreless" }, "total" : 500 }
*/

				  
/*2  Consulta*/
db.capturasTotal.find({total:{$gt:1000}})
/*
{ "_id" : { "user" : 2, "bicho" : "plastoise" }, "total" : 1150 }
{ "_id" : { "user" : 2, "bicho" : "snoreless" }, "total" : 1150 }
*/

/*3*/ 
db.capturasImportantes.drop()
db.createView("capturasImportantes","capturas", 
[{'$group': 
			     {_id:{user:'$user',bicho:'$bicho'}, 
			      total:{$sum:"$puntos"}} }, 
					  {'$match':{total:{$gt:1000}} }, 
				  {'$sort':{_id:1}} ]) 
db.capturasImportantes.find()		  
				  
/*
{ "_id" : { "user" : 2, "bicho" : "plastoise" }, "total" : 1150 }
{ "_id" : { "user" : 2, "bicho" : "snoreless" }, "total" : 1150 }
*/
				  
/*4*/
db.masPuntos.drop()
db.createView("masPuntos","capturas", 
             [{'$group': 
			     {_id:'$user', 
			      total:{$sum:"$puntos"}} }, 
				  {'$sort':{total:-1}},{'$limit':1} ])
db.masPuntos.find()

// { "_id" : 2, "total" : 2850 }

/*5*/ db.bichosPorClase.drop()
db.createView("bichosPorClase","bichos",
              [
			  {'$group':{_id:'$clase',bichos:{$push:'$_id'} }}
              ])
db.bichosPorClase.find()	

/*
{ "_id" : "pelma", "bichos" : [ "plastoise" ] }
{ "_id" : "parrilla", "bichos" : [ "chorizard", "belcebuh" ] }
{ "_id" : "malote", "bichos" : [ "snoreless" ] }
{ "_id" : "aire", "bichos" : [ "cassandro" ] }
*/

/*6*/ 
db.puntosMedio.drop()
db.createView("puntosMedio","capturas",
              [
			  {'$group':{_id:'$user',mediauser:{$avg:'$puntos'} }},
			  {'$group':{_id:null,media:{$avg:'$mediauser'} }},
              ])
db.puntosMedio.find()	
/*
{ "_id" : null, "media" : 313.968253968254
 }
*/

/*7*/
db.capturasTotalPorNombre.drop()
db.createView("capturasTotalPorNombre","capturasTotal",
        [
			  {$lookup: { 
			    from: "users",
                localField: "_id.user",
                foreignField: "_id",
                as: "usuario"} },
			 	
              ])
db.capturasTotalPorNombre.find()	

/*
{ "_id" : { "user" : 1, "bicho" : "cassandro" }, "total" : 650, "usuario" : [ { "_id" : 1, "nombre" : "bertoldo", "fecha" : ISODate("2016-07-07T00:00:00Z") } ] }
{ "_id" : { "user" : 1, "bicho" : "chorizard" }, "total" : 125, "usuario" : [ { "_id" : 1, "nombre" : "bertoldo", "fecha" : ISODate("2016-07-07T00:00:00Z") } ] }
{ "_id" : { "user" : 1, "bicho" : "snoreless" }, "total" : 950, "usuario" : [ { "_id" : 1, "nombre" : "bertoldo", "fecha" : ISODate("2016-07-07T00:00:00Z") } ] }
{ "_id" : { "user" : 2, "bicho" : "cassandro" }, "total" : 550, "usuario" : [ { "_id" : 2, "nombre" : "herminia", "fecha" : ISODate("2017-02-02T01:02:00Z") } ] }
{ "_id" : { "user" : 2, "bicho" : "plastoise" }, "total" : 1150, "usuario" : [ { "_id" : 2, "nombre" : "herminia", "fecha" : ISODate("2017-02-02T01:02:00Z") } ] }
{ "_id" : { "user" : 2, "bicho" : "snoreless" }, "total" : 1150, "usuario" : [ { "_id" : 2, "nombre" : "herminia", "fecha" : ISODate("2017-02-02T01:02:00Z") } ] }
{ "_id" : { "user" : 3, "bicho" : "belcebuh" }, "total" : 50, "usuario" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") } ] }
{ "_id" : { "user" : 3, "bicho" : "cassandro" }, "total" : 750, "usuario" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") } ] }
{ "_id" : { "user" : 3, "bicho" : "chorizard" }, "total" : 430, "usuario" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") } ] }
{ "_id" : { "user" : 3, "bicho" : "snoreless" }, "total" : 500, "usuario" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") } ] }
*/

/*8*/
db.capturadores.drop()
db.createView("capturadores","capturas",        [
			  {$lookup: { 
			    from: "users",
                localField: "user",
                foreignField: "_id",
                as: "usuario"} },
			  {$unwind:{path:"$usuario"}},
			  {$group:{_id:'$bicho', usuarios:{$addToSet:"$usuario"}}}	
              ])
db.capturadores.find()

/*
{ "_id" : "belcebuh", "usuarios" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") } ] }
{ "_id" : "plastoise", "usuarios" : [ { "_id" : 2, "nombre" : "herminia", "fecha" : ISODate("2017-02-02T01:02:00Z") } ] }
{ "_id" : "snoreless", "usuarios" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") }, { "_id" : 2, "nombre" : "herminia", "fecha" : ISODate("2017-02-02T01:02:00Z") }, { "_id" : 1, "nombre" : "bertoldo", "fecha" : ISODate("2016-07-07T00:00:00Z") } ] }
{ "_id" : "cassandro", "usuarios" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") }, { "_id" : 2, "nombre" : "herminia", "fecha" : ISODate("2017-02-02T01:02:00Z") }, { "_id" : 1, "nombre" : "bertoldo", "fecha" : ISODate("2016-07-07T00:00:00Z") } ] }
{ "_id" : "chorizard", "usuarios" : [ { "_id" : 3, "nombre" : "calixto", "fecha" : ISODate("2017-03-03T02:03:00Z") }, { "_id" : 1, "nombre" : "bertoldo", "fecha" : ISODate("2016-07-07T00:00:00Z") } ] }			  		  		  		  		  		  		  		  
*/

/*9 Copiar función map, función reduce y la llamada a mapreduce */
var fmap = function(){
emit({user:this.user,bicho:this.bicho}, this.puntos);}
		
var freduce = function(userbicho,puntos){
     return Array.sum(puntos);};
 
db.capturas.mapReduce(fmap,
                       freduce,
                       {out: {inline:1}}
                      )

/*
{
        "results" : [
                {
                        "_id" : {
                                "user" : 1,
                                "bicho" : "cassandro"
                        },
                        "value" : 650
                },
                {
                        "_id" : {
                                "user" : 1,
                                "bicho" : "chorizard"
                        },
                        "value" : 125
                },
                {
                        "_id" : {
                                "user" : 1,
                                "bicho" : "snoreless"
                        },
                        "value" : 950
                },
                {
                        "_id" : {
                                "user" : 2,
                                "bicho" : "cassandro"
                        },
                        "value" : 550
                },
                {
                        "_id" : {
                                "user" : 2,
                                "bicho" : "plastoise"
                        },
                        "value" : 1150
                },
                {
                        "_id" : {
                                "user" : 2,
                                "bicho" : "snoreless"
                        },
                        "value" : 1150
                },
                {
                        "_id" : {
                                "user" : 3,
                                "bicho" : "belcebuh"
                        },
                        "value" : 50
                },
                {
                        "_id" : {
                                "user" : 3,
                                "bicho" : "cassandro"
                        },
                        "value" : 750
                },
                {
                        "_id" : {
                                "user" : 3,
                                "bicho" : "chorizard"
                        },
                        "value" : 430
                },
                {
                        "_id" : {
                                "user" : 3,
                                "bicho" : "snoreless"
                        },
                        "value" : 500
                }
        ],
        "timeMillis" : 83,
        "counts" : {
                "input" : 20,
                "emit" : 20,
                "reduce" : 3,
                "output" : 10
        },
        "ok" : 1
}
*/					  


/*10*/
db.evolucion.drop()

db.createView("evolucion","capturasTotal" ,
              [
			  {$lookup: { 
			    from: "bichos",
                localField: "_id.bicho",
                foreignField: "_id",
                as: "datosbicho"} },
			   {$unwind:{path:"$datosbicho"}},
			   {$project: {total:1,diff:{'$subtract':["$total","$datosbicho.pts"]}}},
			   {$match:{diff:{$gt:0}}},
			   {$project:{diff:0} }
              ])
			  
db.evolucion.find()	

/*
{ "_id" : { "user" : 1, "bicho" : "cassandro" }, "total" : 650 }
{ "_id" : { "user" : 2, "bicho" : "snoreless" }, "total" : 1150 }
{ "_id" : { "user" : 3, "bicho" : "cassandro" }, "total" : 750 }
*/		  		  		  		  		  		  		  		  

