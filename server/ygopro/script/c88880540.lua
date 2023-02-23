--加油啊！这把可不能输！
function c88880540.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c88880540.target)
	e1:SetOperation(c88880540.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP) 
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCondition(c88880540.descon)
	e3:SetTarget(c88880540.destg)
	e3:SetOperation(c88880540.desop)
	c:RegisterEffect(e3)
end
function c88880540.filter(c,e,tp)
	return c:IsSetCard(0xd88) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88880540.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88880540.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88880540.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c88880540.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c88880540.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c88880540.eqlimit(e,c)
	return e:GetOwner()==c
end
function c88880540.descon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget() 
	return ec and ec:GetBattleTarget()~=nil 
end
function c88880540.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget() 
	local bc=ec:GetBattleTarget()
	if chk==0 then return true end 
	e:SetLabelObject(bc) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c88880540.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end






