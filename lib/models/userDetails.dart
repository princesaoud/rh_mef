class UserDetails {
  var id;
  String matricule;
  String nom;
  String sexe;
  String nom_pere;
  String nom_mere;
  String tel_domicile;
  String tel_bureau;
  String cellulaire;
  String adresse;
  String email;
  String sitmat;
  String date_nais;
  String lieu_nais;
  String nbre_enf;
  String prise_service;
  String type_agent;
  String grade;
  String emloi;
  String echelle;
  String date_emploi;
  String fonction;
  String lib_dg;
  String lib_dir;
  String lib_sr;
  String lib_sce;
  String mut_date_debut;
  String code_sp;
  String sous_prefecture;
  String departement;
  String region;
  String district;
  String lieu_pays;
  String position;
  String date_position;
  String date_retraite;
  String date_1ere_ps;
  String date_prise_serv_structure;
  String nat_libelle;
  String hfonc_reference;
  String created;
  String modified;
  // String created_at;
  // String updated_at;

  UserDetails({
    this.id,
    this.matricule,
    this.nom,
    this.sexe,
    this.nom_pere,
    this.nom_mere,
    this.tel_domicile,
    this.tel_bureau,
    this.cellulaire,
    this.adresse,
    this.email,
    this.sitmat,
    this.date_nais,
    this.lieu_nais,
    this.nbre_enf,
    this.prise_service,
    this.type_agent,
    this.grade,
    this.emloi,
    this.echelle,
    this.date_emploi,
    this.fonction,
    this.lib_dg,
    this.lib_dir,
    this.lib_sr,
    this.lib_sce,
    this.mut_date_debut,
    this.code_sp,
    this.sous_prefecture,
    this.departement,
    this.region,
    this.district,
    this.lieu_pays,
    this.position,
    this.date_position,
    this.date_retraite,
    this.date_1ere_ps,
    this.date_prise_serv_structure,
    this.nat_libelle,
    this.hfonc_reference,
    this.created,
    this.modified,
  }
      // this.created_at,
      // this.updated_at
      );

  @override
  String toString() {
    return 'UserDetails{id: $id, matricule: $matricule, nom: $nom, sexe: $sexe, nom_pere: $nom_pere,'
        ' nom_mere: $nom_mere, tel_domicile: $tel_domicile, tel_bureau: $tel_bureau, cellulaire: $cellulaire, '
        'adresse: $adresse, email: $email, sitmat: $sitmat, date_nais: $date_nais, lieu_nais: $lieu_nais, nbre_enf: $nbre_enf,'
        ' prise_service: $prise_service, type_agent: $type_agent, grade: $grade, emloi: $emloi, echelle: $echelle, '
        'date_emploi: $date_emploi, fonction: $fonction, lib_dg: $lib_dg, lib_dir: $lib_dir, lib_sr: $lib_sr, lib_sce: $lib_sce,'
        ' mut_date_debut: $mut_date_debut, code_sp: $code_sp, sous_prefecture: $sous_prefecture, departement: $departement, '
        'region: $region, district: $district, lieu_pays: $lieu_pays, position: $position, date_position: $date_position,'
        ' date_retraite: $date_retraite, date_1ere_ps: $date_1ere_ps, date_prise_serv_structure: $date_prise_serv_structure, '
        'nat_libelle: $nat_libelle, hfonc_reference: $hfonc_reference, created: $created, modified: $modified,'
        // ' created_at: $created_at, '
        // 'updated_at: $updated_at'
        '}';
  }

  UserDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        matricule = json['matricule'],
        nom = json['nom'],
        sexe = json['sexe'],
        nom_pere = json['nom_pere'],
        nom_mere = json['nom_mere'],
        tel_domicile = json['tel_domicile'],
        tel_bureau = json['tel_bureau'],
        cellulaire = json['cellulaire'],
        adresse = json['adresse'],
        email = json['email'],
        date_nais = json['date_nais'],
        lieu_nais = json['lieu_nais'],
        nbre_enf = json['nbre_enf'],
        date_emploi = json['date_emploi'],
        fonction = json['fonction'],
        lib_dg = json['lib_dg'],
        lib_dir = json['lib_dir'],
        lib_sr = json['lib_sr'],
        lib_sce = json['lib_sce'],
        mut_date_debut = json['mut_date_debut'],
        code_sp = json['code_sp'],
        sous_prefecture = json['sous_prefecture'],
        departement = json['departement'],
        date_retraite = json['date_retraite'],
        date_1ere_ps = json['date_1ere_ps'],
        date_prise_serv_structure = json['date_prise_serv_structure'],
        nat_libelle = json['nat_libelle'],
        hfonc_reference = json['hfonc_reference'],
        created = json['created'],
        modified = json['modified'];
  // created_at = json['created_at'],
  // updated_at = json['updated_at'];
}
