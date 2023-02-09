--圣光之矛
function c27819017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--destroy 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c27819017.dstg) 
	e2:SetOperation(c27819017.dsop) 
	c:RegisterEffect(e2) 
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c27819017.mtop)
	c:RegisterEffect(e4)
end  
c27819017.SetCard_XXLight=true 
function c27819017.dsfil(c,e,tp) 
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)  
end 
function c27819017.dstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27819017.dsfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,LOCATION_ONFIELD)
end 
function c27819017.dsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c27819017.dsfil,tp,LOCATION_MZONE,0,nil,e,tp) 
	if g1:GetCount()>0 then 
	local dg=g1:Select(tp,1,1,nil) 
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,dg) 
	dg:Merge(g2) 
	Duel.Destroy(dg,REASON_EFFECT)
	dg:KeepAlive()   
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e1:SetRange(LOCATION_GRAVE) 
	e1:SetLabelObject(dg) 
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c27819017.spcon) 
	e1:SetOperation(c27819017.spop)
	e1:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e1,tp) 
	end 
end 
function c27819017.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function c27819017.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local dg=e:GetLabelObject() 
	local sg=dg:Filter(c27819017.spfil,nil,e,tp)
	return Duel.GetTurnCount()~=e:GetLabel() and sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=sg:GetCount() 
end  
function c27819017.spop(e,tp,eg,ep,ev,re,r,rp) 
	local dg=e:GetLabelObject() 
	local sg=dg:Filter(c27819017.spfil,nil,e,tp)
	Duel.Hint(HINT_CARD,0,27819017) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end 
function c27819017.mtop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetTurnPlayer()~=tp then return end 
	if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(27819017,0)) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end








