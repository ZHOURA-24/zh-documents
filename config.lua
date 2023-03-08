Config = {}
Config.CoreName = "QBCore"
Config.MenuKey = 121
Config.Font = 4
Config.Locale = "en"

Config.Printmodel = 'prop_printer_01'

Config.Printer = {
  {
    printer_model = "prop_printer_02",
    coords = vector3(443.4, -980.2, 30.89),
    rotation = vector3(0.0, 0.0, 350),
  },
  {
    printer_model = 'prop_printer_02',
    coords = vector3(441.47, -980.33, 30.89),
    rotation = vector3(0.0, 0.0, 47.0),
  }
}

Config.Docs = {
  ["public"] = {
    {
      headerTitle = "FORMULIR KONFIRMASI",
      headerSubtitle = "Formulir Konfirmasi Sipil",
      elements = {
        { label = "ISI KONFIRMASI", type = "textarea", value = "", can_be_emtpy = false },
      }
    },
    {
      headerTitle = "TESTIMONI SAKSI",
      headerSubtitle = "Pernyataan saksi resmi",
      elements = {
        { label = "TANGGAL KEJADIAN", type = "input",    value = "", can_be_emtpy = false },
        { label = "ISI ACARA",        type = "textarea", value = "", can_be_emtpy = false },
      }
    },
    {
      headerTitle = "DOKUMEN TRANSFER MOBIL",
      headerSubtitle = "Memindahkan mobil ke seseorang",
      elements = {
        { label = "NOMOR MOBIL",       type = "input",    value = "", can_be_emtpy = false },
        { label = "NAMA ORANG",        type = "input",    value = "", can_be_emtpy = false },
        { label = "HARGA PERJANJIAN",  type = "input",    value = "", can_be_empty = false },
        { label = "INFORMASI LAINNYA", type = "textarea", value = "", can_be_emtpy = true },
      }
    },
    {
      headerTitle = "PERNYATAAN UNTUK MEMPEROLEH PINJAMAN",
      headerSubtitle = "",
      elements = {
        { label = "NAMA KREDITOR",         type = "input",    value = "", can_be_emtpy = false },
        { label = "NAMA PEMBERI PINJAMAN", type = "input",    value = "", can_be_emtpy = false },
        { label = "JUMLAH UTANG",          type = "input",    value = "", can_be_empty = false },
        { label = "SAAT INI",              type = "input",    value = "", can_be_empty = false },
        { label = "INFORMASI LAINNYA",     type = "textarea", value = "", can_be_emtpy = true },
      }
    },
    {
      headerTitle = "PERNYATAAN PEMBAYARAN PINJAMAN",
      headerSubtitle = "",
      elements = {
        { label = "NAMA DEBITUR", type = "input", value = "", can_be_emtpy = false },
        { label = "NAMA DEBITUR", type = "input", value = "", can_be_emtpy = false },
        { label = "JUMLAH UTANG", type = "input", value = "", can_be_empty = false },
        {
          label = "INFORMASI LAINNYA",
          type = "textarea",
          value =
          "SAYA MENYATAKAN BAHWA DEBITUR TELAH MEMBAYAR PINJAMANNYA.",
          can_be_emtpy = false,
          can_be_edited = false
        },
      }
    }
  },
  ["police"] = {
    {
      headerTitle = "IZIN SENJATA",
      headerSubtitle = "Izin senjata khusus dikeluarkan oleh polisi.",
      elements = {
        { label = "NAMA PEMILIK",   type = "input", value = "", can_be_emtpy = false },
        { label = "NAMA PEMILIK",   type = "input", value = "", can_be_emtpy = false },
        { label = "BERLAKU HINGGA", type = "input", value = "", can_be_empty = false },
        {
          label = "INFORMASI",
          type = "textarea",
          value =
          "WARGA NEGARA YANG TERCANTUM BERHAK MENGGUNAKAN SENJATA SAMPAI BERAKHIRNYA DOKUMEN BERLAKU",
          can_be_emtpy = false
        },
      }
    },
    {
      headerTitle = "PEMBERSIHAN CATATAN PIDANA",
      headerSubtitle = "",
      elements = {
        { label = "NAMA WARGA",       type = "input", value = "", can_be_emtpy = false },
        { label = "NAMA WARGA WARGA", type = "input", value = "", can_be_emtpy = false },
        { label = "BERLAKU SAMPAI",   type = "input", value = "", can_be_empty = false },
        {
          label = "RECORD",
          type = "textarea",
          value =
          "POLISI MENYATAKAN WARGA WARGA PUNYA REKAM YANG BERSIH SAMPAI AKHIR KEBERSAHAN DOKUMEN",
          can_be_emtpy = false,
          can_be_edited = false
        },
      }
    }
  },
  ["ambulance"] = {
    {
      headerTitle = " LAPORAN MEDIS PATOLOGI",
      headerSubtitle = "Laporan medis resmi yang diberikan oleh ahli patologi",
      elements = {
        { label = "NAMA WARGA",       type = "input", value = "", can_be_emtpy = false },
        { label = "NAMA WARGA WARGA", type = "input", value = "", can_be_emtpy = false },
        { label = "BERLAKU SAMPAI",   type = "input", value = "", can_be_empty = false },
        {
          label = "REKAM MEDIS",
          type = "textarea",
          value =
          "Warga tersebut di atas diperiksa oleh petugas kesehatan dan dinyatakan sehat tanpa penyakit jangka panjang yang terdeteksi. Laporan ini berlaku sampai dengan tanggal yang disebutkan",
          can_be_emtpy = false
        },
      }
    },
    {
      headerTitle = "LAPORAN MEDIS - TES PSIKO",
      headerSubtitle = "Laporan medis resmi disediakan oleh psikolog.",
      elements = {
        { label = "INSURED FIRSTNAME", type = "input", value = "", can_be_emtpy = false },
        { label = "INSURED LASTNAME",  type = "input", value = "", can_be_emtpy = false },
        { label = "VALID UNTIL",       type = "input", value = "", can_be_empty = false },
        {
          label = "MEDICAL NOTES",
          type = "textarea",
          value =
          "Warga negara tersebut diperiksa oleh petugas kesehatan dan dinyatakan sehat mental dengan standar terendah yang disetujui. Laporan ini berlaku sampai dengan tanggal yang disebutkan.",
          can_be_emtpy = false
        },
      }
    },
    {
      headerTitle = "LAPORAN MEDIS - SPESIALIS MATA",
      headerSubtitle = "Laporan medis resmi disediakan oleh spesialis mata.",
      elements = {
        { label = "INSURED FIRSTNAME", type = "input", value = "", can_be_emtpy = false },
        { label = "INSURED LASTNAME",  type = "input", value = "", can_be_emtpy = false },
        { label = "VALID UNTIL",       type = "input", value = "", can_be_empty = false },
        {
          label = "MEDICAL NOTES",
          type = "textarea",
          value =
          "Warga tersebut diperiksa oleh petugas kesehatan dan dinyatakan sehat tanpa penyakit mata. Laporan ini berlaku sampai dengan tanggal yang disebutkan",
          can_be_emtpy = false
        },
      }
    },

    ["lawyer"] = {
      {
        headerTitle = "PERJANJIAN UNTUK LAYANAN HUKUM",
        headerSubtitle = "Kontrak untuk layanan hukum yang dibuat oleh seorang pengacara",
        elements = {
          { label = "NAMA WARGA",       type = "input", value = "", can_be_emtpy = false },
          { label = "NAMA WARGA WARGA", type = "input", value = "", can_be_emtpy = false },
          { label = "BERLAKU SAMPAI",   type = "input", value = "", can_be_empty = false },
          {
            label = "INFORMASI",
            type = "textarea",
            value =
            "TDOKUMENNYA ADALAH BUKTI PERNYATAAN HUKUM DAN CAKUPAN WARGA NEGARA TERSEBUT. LAYANAN HUKUM BERLAKU SAMPAI TANGGAL BERAKHIRNYA DI ATAS",
            can_be_emtpy = false
          },
        }
      }
    }
  }
}
