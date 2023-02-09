--圣光终临
function c27819015.initial_effect(c) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819015,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,27819015)
	e1:SetCondition(c27819015.setcon) 
	e1:SetCost(c27819015.setcost)
	e1:SetTarget(c27819015.settg)
	e1:SetOperation(c27819015.setop)
	c:RegisterEffect(e1)  
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c27819015.handcon)
	c:RegisterEffect(e2)   
end 
c27819015.SetCard_XXLight=true 
function c27819015.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c.SetCard_XXLight and c:IsPreviousControler(tp) 
end
function c27819015.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819015.cfilter,1,nil,tp)
end
function c27819015.setcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,500) end 
	Duel.PayLPCost(tp,500)
end 
function c27819015.stfilter(c)
	return c.SetCard_XXLight and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c27819015.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819015.stfilter,tp,LOCATION_DECK,0,1,nil) end 
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
	Duel.SetChainLimit(c27819015.chlimit) 
	end 
end
function c27819015.chlimit(e,ep,tp)
	return tp==ep
end
function c27819015.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c27819015.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)   
	e1:SetCondition(c27819015.actcon)
	e1:SetOperation(c27819015.actop) 
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end 
function c27819015.actcon(e,tp,eg,ep,ev,re,r,rp) 
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==e:GetLabelObject() 
end 
function c27819015.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,27819015)
	Duel.SetChainLimit(c27819015.chainlm)   
end
function c27819015.chainlm(e,rp,tp)
	return tp==rp
end
function c27819015.handcon(e)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_SZONE,0,nil)==0
end


