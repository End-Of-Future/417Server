--通往天堂的圣光之路
function c27819016.initial_effect(c)
	c:SetUniqueOnField(1,0,27819016) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--lv up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819016,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,27819016) 
	e1:SetCost(c27819016.cost)
	e1:SetTarget(c27819016.target)
	e1:SetOperation(c27819016.operation)
	c:RegisterEffect(e1)
	--sy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819016,3)) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,17819016) 
	e2:SetTarget(c27819016.sytg)
	e2:SetOperation(c27819016.syop)
	c:RegisterEffect(e2)
end 
c27819016.SetCard_XXLight=true 
function c27819016.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1000) end 
	Duel.PayLPCost(tp,1000)
end 
function c27819016.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c.SetCard_XXLight 
end
function c27819016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c27819016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27819016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c27819016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetFirst():IsLevel(1) then
		op=Duel.SelectOption(tp,aux.Stringid(27819016,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(27819016,1),aux.Stringid(27819016,2))
	end
	e:SetLabel(op)
end
function c27819016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		tc:RegisterEffect(e1)
	end
end 
function c27819016.symfil(c) 
	return c:IsFaceup() and c.SetCard_XXLight and c:IsCanBeSynchroMaterial()
end 
function c27819016.sytg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local mg=Duel.GetMatchingGroup(c27819016.symfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg,1,99) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c27819016.syop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c27819016.symfil,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg,1,99)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg,1,99) 
	--immune
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(27819016,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c27819016.efilter) 
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	sg:GetFirst():RegisterEffect(e1)
	end
end
function c27819016.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end



