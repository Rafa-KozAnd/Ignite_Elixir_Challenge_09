defmodule Rockelivery.Stack do
  use GenServer

  ############### ----CLIENT----#############

  def start_link(inicial_stack) when is_list(inicial_stack) do
    GenServer.start_link(__MODULE__, inicial_stack)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  ############### ----GENSERVER----#############
  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  # função sync
  def handle_call({:push, element}, _from, state) do
    # Devolvendo messagem para quem chamou :reply
    # Retorno da messagem, por exemplo "Processei"
    # Estado atual do genserver
    {:reply, [element | state], [element | state]}
  end

  @impl true
  def handle_call(:pop, _from, [head, tail]) do
    # Devolvendo messagem para quem chamou :reply
    # Retorno da messagem, por exemplo "Processei"
    # Estado atual do genserver

    {:reply, head, tail}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    # Devolvendo messagem para quem chamou :reply
    # Retorno da messagem, por exemplo "Processei"
    # Estado atual do genserver

    {:reply, nil, []}
  end

  # @impl true
  # #função assincrona, não devolve um messagem
  # def handle_cast({:push, element} state) do
  #   # Não devolve messagem para que chamou :noreply
  #   {:noreply, [element | state]}
  # end
end
