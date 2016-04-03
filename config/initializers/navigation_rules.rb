# This rules are used to create page titles and navigation bar.
NAVIGATION_RULES = {
    # Root categories.
    my_profile: {
        icon: 'fa fa-user',
        title: :my_profile
    },
    general: {
        icon: 'fa fa-database',
        title: :general
    },
    production: {
        icon: 'fa fa-cog',
        title: :production
    },
    administration: {
        icon: 'fa fa-users',
        title: :administration
    },
    dashboard: {
        index: {
            title: :general
        }
    },

    # Navigation inside categories.
    registrations: {
        edit: {
            parent: :my_profile,
            title: :edit_account
        },
        update: {
            parent: :my_profile,
            title: :edit_account
        }
    },

    payment_methods: {
        index: {
            parent: :general,
            title: 'payment_methods.title'
        },
        new: {
            parent: { controller: :payment_methods, action: :index, params: [ :user_id ] },
            title: :new_payment_method
        },
        create: {
            parent: { controller: :payment_methods, action: :index, params: [ :user_id ] },
            title: :new_payment_method
        },
        edit: {
            parent: { controller: :payment_methods, action: :index, params: [ :user_id ] },
            title: :update_payment_method
        },
        update: {
            parent: { controller: :payment_methods, action: :index, params: [ :user_id ] },
            title: :update_payment_method
        }
    },
    vats: {
        index: {
            parent: :general,
            title: 'vats.title'
        },
        new: {
            parent: { controller: :vats, action: :index, params: [ :user_id ] },
            title: 'vats.create_title'
        },
        create: {
            parent: { controller: :vats, action: :index, params: [ :user_id ] },
            title: 'vats.create_title'
        },
        edit: {
            parent: { controller: :vats, action: :index, params: [ :user_id ] },
            title: 'vats.edit_title'
        },
        update: {
            parent: { controller: :vats, action: :index, params: [ :user_id ] },
            title: 'vats.edit_title'
        }
    },
    units: {
        index: {
            parent: :general,
            title: 'units.title'
        },
        new: {
            parent: { controller: :units, action: :index, params: [ :user_id ] },
            title: 'units.create_title'
        },
        create: {
            parent: { controller: :units, action: :index, params: [ :user_id ] },
            title: 'units.create_title'
        },
        edit: {
            parent: { controller: :units, action: :index, params: [ :user_id ] },
            title: 'units.edit_title'
        },
        update: {
            parent: { controller: :units, action: :index, params: [ :user_id ] },
            title: 'units.edit_title'
        }
    },
    services: {
        index: {
            parent: :general,
            title: 'services.title'
        },
        new: {
            parent: { controller: :services, action: :index, params: [ :user_id ] },
            title: 'services.create_title'
        },
        create: {
            parent: { controller: :services, action: :index, params: [ :user_id ] },
            title: 'services.create_title'
        },
        edit: {
            parent: { controller: :services, action: :index, params: [ :user_id ] },
            title: 'services.edit_title'
        },
        update: {
            parent: { controller: :services, action: :index, params: [ :user_id ] },
            title: 'services.edit_title'
        }
    },
    customers: {
        index: {
            parent: :general,
            title: 'customers.title'
        },
        new: {
            parent: { controller: :customers, action: :index, params: [ :user_id ] },
            title: 'customers.create_title'
        },
        create: {
            parent: { controller: :customers, action: :index, params: [ :user_id ] },
            title: 'customers.create_title'
        },
        edit: {
            parent: { controller: :customers, action: :index, params: [ :user_id ] },
            title: 'customers.edit_title'
        },
        update: {
            parent: { controller: :customers, action: :index, params: [ :user_id ] },
            title: 'customers.edit_title'
        }
    },
    estimates: {
        index: {
            parent: :production,
            title: 'estimates.title'
        },
        show: {
            parent: { controller: :estimates, action: :index, params: [ :user_id ] },
            title: 'estimates.print_title'
        },
        new: {
            parent: { controller: :estimates, action: :index, params: [ :user_id ] },
            title: 'estimates.create_title'
        },
        create: {
            parent: { controller: :estimates, action: :index, params: [ :user_id ] },
            title: 'estimates.create_title'
        },
        edit: {
            parent: { controller: :estimates, action: :index, params: [ :user_id ] },
            title: 'estimates.edit_title'
        },
        update: {
            parent: { controller: :estimates, action: :index, params: [ :user_id ] },
            title: 'estimates.edit_title'
        }
    },
    delivery_notes: {
        index: {
            parent: :production,
            title: 'delivery_notes.title'
        },
        show: {
            parent: { controller: :delivery_notes, action: :index, params: [ :user_id ] },
            title: 'delivery_notes.print_title'
        },
        new: {
            parent: { controller: :delivery_notes, action: :index, params: [ :user_id ] },
            title: 'delivery_notes.create_title'
        },
        create: {
            parent: { controller: :delivery_notes, action: :index, params: [ :user_id ] },
            title: 'delivery_notes.create_title'
        },
        edit: {
            parent: { controller: :delivery_notes, action: :index, params: [ :user_id ] },
            title: 'delivery_notes.edit_title'
        },
        update: {
            parent: { controller: :delivery_notes, action: :index, params: [ :user_id ] },
            title: 'delivery_notes.edit_title'
        }
    },
    invoices: {
        index: {
            parent: :production,
            title: 'invoices.title'
        },
        show: {
            parent: { controller: :invoices, action: :index, params: [ :user_id ] },
            title: 'invoices.print_title'
        },
        new: {
            parent: { controller: :invoices, action: :index, params: [ :user_id ] },
            title: 'invoices.create_title'
        },
        create: {
            parent: { controller: :invoices, action: :index, params: [ :user_id ] },
            title: 'invoices.create_title'
        },
        edit: {
            parent: { controller: :invoices, action: :index, params: [ :user_id ] },
            title: 'invoices.edit_title'
        },
        update: {
            parent: { controller: :invoices, action: :index, params: [ :user_id ] },
            title: 'invoices.edit_title'
        }
    },
    projects: {
        index: {
            parent: :production,
            title: 'projects.title'
        },
        new: {
            parent: { controller: :projects, action: :index, params: [ :user_id ] },
            title: 'projects.create_title'
        },
        create: {
            parent: { controller: :projects, action: :index, params: [ :user_id ] },
            title: 'projects.create_title'
        },
        edit: {
            parent: { controller: :projects, action: :index, params: [ :user_id ] },
            title: 'projects.edit_title'
        },
        update: {
            parent: { controller: :projects, action: :index, params: [ :user_id ] },
            title: 'projects.edit_title'
        }
    },
    tasks: {
        index: {
            parent: { controller: :projects, action: :index, params: [ :user_id ] },
            title: 'tasks.title'
        },
        new: {
            parent: { controller: :tasks, action: :index, params: [ :user_id, :project_id ] },
            title: 'tasks.create_title'
        },
        create: {
            parent: { controller: :tasks, action: :index, params: [ :user_id, :project_id ] },
            title: 'tasks.create_title'
        },
        edit: {
            parent: { controller: :tasks, action: :index, params: [ :user_id, :project_id ] },
            title: 'tasks.edit_title'
        },
        update: {
            parent: { controller: :tasks, action: :index, params: [ :user_id, :project_id ] },
            title: 'tasks.edit_title'
        }
    },
    time_logs: {
        index: {
            parent: { controller: :tasks, action: :index, params: [ :user_id, :project_id ] },
            title: 'time_logs.title'
        },
        new: {
            parent: { controller: :time_logs, action: :index, params: [ :user_id, :project_id, :task_id ] },
            title: 'time_logs.create_title'
        },
        create: {
            parent: { controller: :time_logs, action: :index, params: [ :user_id, :project_id, :task_id ] },
            title: 'time_logs.create_title'
        },
        edit: {
            parent: { controller: :time_logs, action: :index, params: [ :user_id, :project_id, :task_id ] },
            title: 'time_logs.edit_title'
        },
        update: {
            parent: { controller: :time_logs, action: :index, params: [ :user_id, :project_id, :task_id ] },
            title: 'time_logs.edit_title'
        }
    },

    plans: {
      index: {
          parent: :administration,
          title: 'plans.title'
      },
      new: {
          parent: { controller: :plans, action: :index },
          title: 'plans.create_title'
      },
    },

    users: {
        index: {
            parent: :administration,
            title: 'users.title'
        }
    }
}