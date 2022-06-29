# frozen_string_literal: true

module DSpace
  class Collection
    attr_reader :data, :page, :size, :total_pages, :next_page, :prev_page, :last_page

    def self.from_response(response, key:, type:)
      body = response.body
      new(
        data: body["_embedded"][key].map { |attrs| type.new(attrs) },
        page: body.dig("page", "number"),
        size: body.dig("page", "size"),
        total_elements: body.dig("page", "totalElements"),
        total_pages: body.dig("page", "totalPages")
      )
    end

    def initialize(data:, page:, size:, total_elements:, total_pages:)
      @data           = data
      @page           = page
      @size           = size
      @total_elements = total_elements
      @total_pages    = total_pages
      @first_page     = 0
      @next_page      = resolve_next_page(page)
      @prev_page      = resolve_prev_page(page)
      @last_page      = resolve_last_page(total_pages)
    end

    def resolve_next_page(page)
      page + 1 <= resolve_last_page(total_pages) ? (page + 1) : nil
    end

    def resolve_prev_page(page)
      page - 1 >= 0 ? (page - 1) : nil
    end

    def resolve_last_page(total)
      total - 1 >= 0 ? (total - 1) : 0
    end
  end
end
