# This rules are used to create page titles and navigation bar.
NAVIGATION_RULES = {
    registrations: {
        root: {
              icon: 'fa fa-user',
              title: :my_profile
        },
        edit: {
            title: :edit_account
        }
    },
    dashboard: {
      index: {
          title: :general
      }
    },
    payment_methods: {
        root: {
            icon: 'fa fa-database',
            title: :general
        },
        index: {
            title: :payment_methods
        },
        new: {
            parent: :index,
            title: :new_payment_method
        },
        edit: {
            parent: :index,
            title: :update_payment_method
        }
    },
    vats: {
        root: {
            icon: 'fa fa-database',
            title: :general
        },
        index: {
            title: 'vats.title'
        },
        new: {
            parent: :index,
            title: 'vats.create_title'
        },
        edit: {
            parent: :index,
            title: 'vats.edit_title'
        }
    },
    units: {
        root: {
            icon: 'fa fa-database',
            title: :general
        },
        index: {
            title: 'units.title'
        },
        new: {
            parent: :index,
            title: 'units.create_title'
        },
        edit: {
            parent: :index,
            title: 'units.edit_title'
        }
    },
    services: {
        root: {
            icon: 'fa fa-database',
            title: :general
        },
        index: {
            title: 'services.title'
        },
        new: {
            parent: :index,
            title: 'services.create_title'
        },
        edit: {
            parent: :index,
            title: 'services.edit_title'
        }
    },
    customers: {
        root: {
            icon: 'fa fa-database',
            title: :general
        },
        index: {
            title: 'customers.title'
        },
        new: {
            parent: :index,
            title: 'customers.create_title'
        },
        edit: {
            parent: :index,
            title: 'customers.edit_title'
        }
    },
    estimates: {
        root: {
            icon: 'fa fa-cog',
            title: :production
        },
        index: {
            title: 'estimates.title'
        },
        new: {
            parent: :index,
            title: 'estimates.create_title'
        },
        edit: {
            parent: :index,
            title: 'estimates.edit_title'
        }
    },
    delivery_notes: {
        root: {
            icon: 'fa fa-cog',
            title: :production
        },
        index: {
            title: 'delivery_notes.title'
        },
        new: {
            parent: :index,
            title: 'delivery_notes.create_title'
        },
        edit: {
            parent: :index,
            title: 'delivery_notes.edit_title'
        }
    },
    invoices: {
        root: {
            icon: 'fa fa-cog',
            title: :production
        },
        index: {
            title: 'invoices.title'
        },
        new: {
            parent: :index,
            title: 'invoices.create_title'
        },
        edit: {
            parent: :index,
            title: 'invoices.edit_title'
        }
    },
    projects: {
        root: {
            icon: 'fa fa-cog',
            title: :production
        },
        index: {
            title: 'projects.title'
        },
        new: {
            parent: :index,
            title: 'projects.create_title'
        },
        edit: {
            parent: :index,
            title: 'projects.edit_title'
        }
    }
}