include { CREATE_ACC2TAX } from '../../modules/local/create_acc2tax'
include { SAM2LCA_PREPDB } from '../../modules/local/sam2lca/prep_db/main'
include { SAM2LCA_UPDATEDB } from '../../modules/local/sam2lca/updatedb/main'

workflow SAM2LCA_DB {
    take:
        genomes // meta, fasta
        taxo_nodes // nodes.dmp
        taxo_names // names.dmp
        taxo_merged // merged.dmp

    main:
        CREATE_ACC2TAX(genomes)

        acc2tax = CREATE_ACC2TAX.out.acc2tax.collectFile(
            name: 'adnamap.accession2taxid',
            keepHeader: true
        )

        SAM2LCA_PREPDB(acc2tax)

        SAM2LCA_UPDATEDB(
            "adnamap",
            "ncbi_local",
            taxo_nodes,
            taxo_names,
            taxo_merged,
            SAM2LCA_PREPDB.out.acc2tax_json,
            SAM2LCA_PREPDB.out.acc2tax_gz,
            SAM2LCA_PREPDB.out.acc2tax_md5
        )

    emit:
        sam2lca_db = SAM2LCA_UPDATEDB.out.sam2lca_db
}
