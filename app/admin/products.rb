ActiveAdmin.register Product do
  permit_params :name, :description, :price, :inventory_count, :image, category_ids: []
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :inventory_count
      f.input :categories
      f.input :image, as: :file
    end
    f.actions
  end
end
